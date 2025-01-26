//
// Created by fairy on 2025/1/25 22:29.
//
#ifndef QTDESKTOP_CALCULATORCTRL_HPP
#define QTDESKTOP_CALCULATORCTRL_HPP

#include <QObject>
#include <QString>

class CalculatorCtrl : public QObject
{
Q_OBJECT
    Q_PROPERTY(QString display READ display WRITE setDisplay NOTIFY displayChanged)

public:
    explicit CalculatorCtrl(QObject *parent = nullptr);

    Q_INVOKABLE void appendNumber(const QString &number);
    Q_INVOKABLE void setOperation(const QString &operation);
    Q_INVOKABLE void calculate();
    Q_INVOKABLE void clear();

    QString display() const;
    void setDisplay(const QString &display);

signals:
    void displayChanged();

private:
    QString m_display;
    QString m_currentOperation;
    double m_firstNumber;
    double m_secondNumber;
    bool m_isOperationSet;
};



#endif //QTDESKTOP_CALCULATORCTRL_HPP