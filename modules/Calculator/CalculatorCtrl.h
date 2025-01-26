//
// Created by fairy on 2025/1/25 22:29.
//
#ifndef QTDESKTOP_CALCULATORCTRL_HPP
#define QTDESKTOP_CALCULATORCTRL_HPP

#include <QObject>
#include <QString>
#include <QStack>
#include <QMap>

class CalculatorCtrl : public QObject
{
Q_OBJECT
    Q_PROPERTY(QString display READ display WRITE setDisplay NOTIFY displayChanged)
    Q_PROPERTY(QString expression READ expression WRITE setExpression NOTIFY expressionChanged)

public:
    explicit CalculatorCtrl(QObject *parent = nullptr);

    Q_INVOKABLE void appendNumber(const QString &number);
    Q_INVOKABLE void appendOperation(const QString &operation);
    Q_INVOKABLE void appendToExpression(const QString &text);
    Q_INVOKABLE void calculate();
    Q_INVOKABLE void clear();
    Q_INVOKABLE void clearAll();
    Q_INVOKABLE void toggleSign();

    QString display() const;
    void setDisplay(const QString &display);
    QString expression() const;
    void setExpression(const QString &expression);

signals:
    void displayChanged();
    void expressionChanged();

private:
    QString m_display;
    QString m_expression;
    QString m_currentOperation;
    double m_firstNumber;
    double m_secondNumber;
    bool m_isOperationSet;

    QString evaluateExpression(const QString &expression);
    void applyOperation(const QString &operation, QStack<double> &numbers);
};


#endif //QTDESKTOP_CALCULATORCTRL_HPP