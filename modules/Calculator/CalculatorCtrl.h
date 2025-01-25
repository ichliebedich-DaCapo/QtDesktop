//
// Created by fairy on 2025/1/25 22:29.
//
#ifndef QTDESKTOP_CALCULATORCTRL_HPP
#define QTDESKTOP_CALCULATORCTRL_HPP
#include <QObject>
#include <QString>

class CalculatorCtrl : public QObject {
Q_OBJECT
    Q_PROPERTY(QString display READ display NOTIFY displayChanged)

public:
    explicit CalculatorCtrl(QObject *parent = nullptr);

    Q_INVOKABLE void appendNumber(const QString &number);
    Q_INVOKABLE void appendDecimal();
    Q_INVOKABLE void setOperator(const QString &op);
    Q_INVOKABLE void clear();
    Q_INVOKABLE void backspace();
    Q_INVOKABLE void calculate();

    QString display() const;

signals:
    void displayChanged();

private:
    QString m_display;
    QString m_operator;
    double m_firstOperand;
    bool m_waitingForOperand;
};


#endif //QTDESKTOP_CALCULATORCTRL_HPP