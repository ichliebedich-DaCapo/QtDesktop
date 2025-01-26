#include "CalculatorCtrl.h"
#include <QDebug>
#include <cmath>
#include <QStack>
#include <QMap>
#include <QRegExp>

CalculatorCtrl::CalculatorCtrl(QObject *parent) : QObject(parent), m_display("0"), m_expression(""), m_currentOperation(""), m_firstNumber(0), m_secondNumber(0), m_isOperationSet(false) {}

void CalculatorCtrl::appendNumber(const QString &number) {
    if (m_display == "0" || m_isOperationSet) {
        m_display = number;
        m_isOperationSet = false;
    } else {
        m_display += number;
    }
    emit displayChanged();
}

void CalculatorCtrl::appendOperation(const QString &operation) {
    if (m_display != "0") {
        m_expression += " " + m_display;
        m_display = "0";  // 清空当前显示
    }

    if (!m_expression.isEmpty() && !m_expression.endsWith(" ")) {
        m_expression += " " + operation + " ";
    } else {
        m_expression += operation + " ";
    }
    m_isOperationSet = true;
    emit expressionChanged();
}

void CalculatorCtrl::appendToExpression(const QString &text) {
    if (text == "(") {
        if (!m_expression.isEmpty() && !m_expression.endsWith(" ")) {
            m_expression += " ";
        }
        m_expression += text;
    } else if (text == ")") {
        if (m_display != "0") {
            m_expression += " " + m_display;
            m_display = "0";  // 清空当前显示
        }
        if (!m_expression.isEmpty() && !m_expression.endsWith(" ")) {
            m_expression += " ";
        }
        m_expression += text;
    } else {
        m_expression += text;
    }
    emit expressionChanged();
}

void CalculatorCtrl::calculate() {
    if (m_expression.isEmpty()) return;

    if (m_display != "0") {
        m_expression += " " + m_display;
        m_display = "0";  // 清空当前显示
    }

    QString result = evaluateExpression(m_expression);
    m_display = result;
    m_expression += " = " + result;
    emit displayChanged();
    emit expressionChanged();
}

void CalculatorCtrl::clear() {
    m_display = "0";
    emit displayChanged();
}

void CalculatorCtrl::clearAll() {
    m_display = "0";
    m_expression = "";
    m_currentOperation = "";
    m_firstNumber = 0;
    m_secondNumber = 0;
    m_isOperationSet = false;
    emit displayChanged();
    emit expressionChanged();
}

void CalculatorCtrl::squareRoot() {
    double number = m_display.toDouble();
    if (number >= 0) {
        m_display = QString::number(std::sqrt(number));
        m_expression = "√(" + QString::number(number) + ") = " + m_display;
    } else {
        m_display = "Error";
        m_expression = "√(" + QString::number(number) + ") = Error";
    }
    emit displayChanged();
    emit expressionChanged();
}

void CalculatorCtrl::square() {
    double number = m_display.toDouble();
    m_display = QString::number(number * number);
    m_expression = "(" + QString::number(number) + ")² = " + m_display;
    emit displayChanged();
    emit expressionChanged();
}

void CalculatorCtrl::toggleSign() {
    double number = m_display.toDouble();
    m_display = QString::number(-number);
    m_expression = "±(" + QString::number(number) + ") = " + m_display;
    emit displayChanged();
    emit expressionChanged();
}

QString CalculatorCtrl::display() const {
    return m_display;
}

void CalculatorCtrl::setDisplay(const QString &display) {
    if (m_display != display) {
        m_display = display;
        emit displayChanged();
    }
}

QString CalculatorCtrl::expression() const {
    return m_expression;
}

void CalculatorCtrl::setExpression(const QString &expression) {
    if (m_expression != expression) {
        m_expression = expression;
        emit expressionChanged();
    }
}

QString CalculatorCtrl::evaluateExpression(const QString &expression) {
    QMap<QString, int> precedence = {
            {"+", 1},
            {"-", 1},
            {"×", 2},
            {"÷", 2},
            {"(", 0},
            {")", 0}
    };

    QStack<QString> operators;
    QStack<double> numbers;
    QStringList tokens = expression.split(" ", Qt::SkipEmptyParts);

    qDebug() << "Tokens:" << tokens;

    for (const QString &token : tokens) {
        qDebug() << "Processing token:" << token;
        if (token == "(") {
            operators.push(token);
        } else if (token == ")") {
            while (!operators.isEmpty() && operators.top() != "(") {
                qDebug() << "Applying operation:" << operators.top();
                applyOperation(operators.pop(), numbers);
            }
            if (!operators.isEmpty() && operators.top() == "(") {
                operators.pop();  // 弹出 "("
            } else {
                qDebug() << "Mismatched parentheses";
                return "Error";
            }
        } else if (precedence.contains(token)) {
            while (!operators.isEmpty() && precedence[operators.top()] >= precedence[token]) {
                qDebug() << "Applying operation:" << operators.top();
                applyOperation(operators.pop(), numbers);
            }
            operators.push(token);
        } else {
            bool ok;
            double number = token.toDouble(&ok);
            if (ok) {
                numbers.push(number);
            } else {
                qDebug() << "Invalid token:" << token;
                return "Error";
            }
        }
        qDebug() << "Operators stack:" << operators;
        qDebug() << "Numbers stack:" << numbers;
    }

    while (!operators.isEmpty()) {
        if (operators.top() == "(" || operators.top() == ")") {
            qDebug() << "Mismatched parentheses";
            return "Error";
        }
        qDebug() << "Applying operation:" << operators.top();
        applyOperation(operators.pop(), numbers);
        qDebug() << "Operators stack:" << operators;
        qDebug() << "Numbers stack:" << numbers;
    }

    if (numbers.isEmpty()) {
        return "Error";
    }
    return QString::number(numbers.pop());
}

void CalculatorCtrl::applyOperation(const QString &operation, QStack<double> &numbers) {
    if (numbers.size() < 2) {
        qDebug() << "Not enough operands for operation:" << operation;
        return;
    }
    double b = numbers.pop();
    double a = numbers.pop();
    double result = 0;

    if (operation == "+") {
        result = a + b;
    } else if (operation == "-") {
        result = a - b;
    } else if (operation == "×") {
        result = a * b;
    } else if (operation == "÷") {
        if (b == 0) {
            qDebug() << "Division by zero";
            result = 0;  // 处理除以零
        } else {
            result = a / b;
        }
    } else {
        qDebug() << "Unknown operation:" << operation;
        return;
    }

    numbers.push(result);
}