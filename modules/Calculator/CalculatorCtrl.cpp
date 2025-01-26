//
// Created by fairy on 2025/1/25 22:29.
//
#include "CalculatorCtrl.h"
#include <QDebug>

CalculatorCtrl::CalculatorCtrl(QObject *parent) : QObject(parent), m_display("0"), m_currentOperation(""), m_firstNumber(0), m_secondNumber(0), m_isOperationSet(false) {}

void CalculatorCtrl::appendNumber(const QString &number) {
    if (m_display == "0" || m_isOperationSet) {
        m_display = number;
        m_isOperationSet = false;
    } else {
        m_display += number;
    }
    emit displayChanged();
}

void CalculatorCtrl::setOperation(const QString &operation) {
    m_firstNumber = m_display.toDouble();
    m_currentOperation = operation;
    m_isOperationSet = true;
}

void CalculatorCtrl::calculate() {
    m_secondNumber = m_display.toDouble();
    double result = 0;

    if (m_currentOperation == "+") {
        result = m_firstNumber + m_secondNumber;
    } else if (m_currentOperation == "-") {
        result = m_firstNumber - m_secondNumber;
    } else if (m_currentOperation == "*") {
        result = m_firstNumber * m_secondNumber;
    } else if (m_currentOperation == "/") {
        result = m_firstNumber / m_secondNumber;
    }

    m_display = QString::number(result);
    emit displayChanged();
}

void CalculatorCtrl::clear() {
    m_display = "0";
    m_currentOperation = "";
    m_firstNumber = 0;
    m_secondNumber = 0;
    m_isOperationSet = false;
    emit displayChanged();
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
