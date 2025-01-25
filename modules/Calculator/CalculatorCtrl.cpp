//
// Created by fairy on 2025/1/25 22:29.
//
#include "CalculatorCtrl.h"

CalculatorCtrl::CalculatorCtrl(QObject *parent) : QObject(parent), m_waitingForOperand(true) {
    clear();
}

void CalculatorCtrl::appendNumber(const QString &number) {
    if (m_waitingForOperand) {
        m_display = number;
        m_waitingForOperand = false;
    } else {
        m_display += number;
    }
    emit displayChanged();
}

void CalculatorCtrl::appendDecimal() {
    if (!m_display.contains('.')) {
        m_display += ".";
    }
    emit displayChanged();
}

void CalculatorCtrl::setOperator(const QString &op) {
    if (!m_waitingForOperand) {
        calculate();
    }
    m_operator = op;
    m_firstOperand = m_display.toDouble();
    m_waitingForOperand = true;
}

void CalculatorCtrl::clear() {
    m_display = "0";
    m_operator = "";
    m_firstOperand = 0.0;
    m_waitingForOperand = true;
    emit displayChanged();
}

void CalculatorCtrl::backspace() {
    if (m_display.length() > 1) {
        m_display.chop(1);
    } else {
        m_display = "0";
    }
    emit displayChanged();
}

void CalculatorCtrl::calculate() {
    double secondOperand = m_display.toDouble();
    double result = 0.0;

    if (m_operator == "+") {
        result = m_firstOperand + secondOperand;
    } else if (m_operator == "-") {
        result = m_firstOperand - secondOperand;
    } else if (m_operator == "×") {
        result = m_firstOperand * secondOperand;
    } else if (m_operator == "÷") {
        result = m_firstOperand / secondOperand;
    }

    m_display = QString::number(result);
    m_waitingForOperand = true;
    emit displayChanged();
}

QString CalculatorCtrl::display() const {
    return m_display;
}
