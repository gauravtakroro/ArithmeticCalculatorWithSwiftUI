//
//  CalculatorView.swift
//  ArithmeticCalculatorWithSwiftUI
//
//  Created by Gaurav Tak on 06/08/23.
//

import SwiftUI

struct CalculatorView: View {
    @State var resultValueDisplayed = "0"
    @State var runningNumberValue = 0.0
    @State var currentArithmeticOperation: ArithmeticOperation = .none
    @State var isArithmeticOperationButtonTapped = false
    @State var expressionOfCalculations = ""
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                HStack (alignment: .top) {
                    Spacer()
                    Text(expressionOfCalculations)
                        .font(.system(size: 20))
                        .foregroundColor(.white).lineLimit(4).frame(alignment: .trailing)
                }.frame(maxWidth: .infinity)
                Spacer()
                
                // Text display
                HStack {
                    Spacer()
                    Text(resultValueDisplayed)
                        .bold()
                        .font(.system(size: 100))
                        .minimumScaleFactor(0.4)
                        .foregroundColor(.white)
                }
                .padding()
                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                //  Button Action Implementation
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(self.buttonBackgroundColor(item: item))
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }
}

extension CalculatorView {
    
    func ridZero(result: Double) -> String {
        let value = String(format: "%g", result)
        return value
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonBackgroundColor(item: CalcButton) -> Color {
        switch item {
        case .add, .subtract, .mutliply, .divide, .equal:
            return .blue
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}
extension CalculatorView {
    
    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .mutliply, .divide, .equal:
            if isArithmeticOperationButtonTapped && (button == .add || button == .divide || button == .mutliply || button == .subtract) {
                didTap(button: .equal)
            }
            if button == .add {
                self.currentArithmeticOperation = .add
                self.runningNumberValue = Double(self.resultValueDisplayed) ?? 0.0
                self.isArithmeticOperationButtonTapped = true
                self.resultValueDisplayed = "\(self.resultValueDisplayed)+"
                if expressionOfCalculations.last != "+" {
                    self.resultValueDisplayed = "+"
                    self.expressionOfCalculations = "\(self.expressionOfCalculations)+"
                }
                
            }
            else if button == .subtract {
                self.currentArithmeticOperation = .subtract
                self.runningNumberValue = Double(self.resultValueDisplayed) ?? 0.0
                self.isArithmeticOperationButtonTapped = true
                if expressionOfCalculations.last != "-" {
                    self.resultValueDisplayed = "-"
                    self.expressionOfCalculations = "\(self.expressionOfCalculations)-"
                }
            }
            else if button == .mutliply {
                self.currentArithmeticOperation = .multiply
                self.runningNumberValue = Double(self.resultValueDisplayed) ?? 0.0
                self.isArithmeticOperationButtonTapped = true
                if expressionOfCalculations.last != "x" {
                    self.resultValueDisplayed = "x"
                    self.expressionOfCalculations = "\(self.expressionOfCalculations)x"
                }
            }
            else if button == .divide {
                self.currentArithmeticOperation = .divide
                self.runningNumberValue = Double(self.resultValueDisplayed) ?? 0.0
                self.isArithmeticOperationButtonTapped = true
                if expressionOfCalculations.last != "/" {
                    self.resultValueDisplayed = "/"
                    self.expressionOfCalculations = "\(self.expressionOfCalculations)/"
                }
            }
            else if button == .equal {
                let runningValue = self.runningNumberValue
                let currentValue = Double(self.resultValueDisplayed) ?? 0.0
                self.isArithmeticOperationButtonTapped = false
                switch self.currentArithmeticOperation {
                case .add: self.resultValueDisplayed = ridZero(result: (runningValue + currentValue))
                case .subtract: self.resultValueDisplayed = ridZero(result: (runningValue - currentValue))
                case .multiply: self.resultValueDisplayed = ridZero(result: (runningValue * currentValue))
                case .divide: self.resultValueDisplayed = ridZero(result: (runningValue / currentValue))
                case .none:
                    break
                }
                expressionOfCalculations = "\(self.expressionOfCalculations)=\(self.resultValueDisplayed)"
            }
        case .clear:
            self.resultValueDisplayed = "0"
            self.expressionOfCalculations = ""
            self.isArithmeticOperationButtonTapped = false
        case .decimal:
            if self.resultValueDisplayed != "+" && self.resultValueDisplayed != "-" && self.resultValueDisplayed != "/" && self.resultValueDisplayed != "x" {
                if self.resultValueDisplayed.contains(".") {
                    // dont do anything
                } else {
                    self.resultValueDisplayed = "\(self.resultValueDisplayed)."
                    self.expressionOfCalculations = "\(self.expressionOfCalculations)."
                }
            } else {
                self.resultValueDisplayed = "."
                self.expressionOfCalculations = "\(self.expressionOfCalculations)."
            }
        case .percent:
            if self.resultValueDisplayed != "+" && self.resultValueDisplayed != "-" && self.resultValueDisplayed != "/" && self.resultValueDisplayed != "x" {
                self.resultValueDisplayed = ridZero(result: (Double(self.resultValueDisplayed) ?? 0.0) / 100.0)
                self.expressionOfCalculations = "\(self.expressionOfCalculations)/100 = \(self.resultValueDisplayed)"
            }
            break
        case .negative:
            if self.resultValueDisplayed != "+" && self.resultValueDisplayed != "-" && self.resultValueDisplayed != "/" && self.resultValueDisplayed != "x" {
                let valueBeforeNegative = Double(self.resultValueDisplayed) ?? 0.0
                self.resultValueDisplayed = ridZero(result:valueBeforeNegative * -1)
                self.expressionOfCalculations = "\(self.expressionOfCalculations)x-1 = \(self.resultValueDisplayed)"
            }
        default:
            let number = button.rawValue
            if self.isArithmeticOperationButtonTapped == true {
                if self.resultValueDisplayed != "+" && self.resultValueDisplayed != "-" && self.resultValueDisplayed != "/" && self.resultValueDisplayed != "x" {
                    self.resultValueDisplayed = "\(self.resultValueDisplayed)\(number)"
                } else {
                    self.resultValueDisplayed = number
                }
            }
            else {
                if self.resultValueDisplayed != "0" {
                    self.resultValueDisplayed = "\(self.resultValueDisplayed)\(number)"
                } else {
                    self.resultValueDisplayed = number
                }
            }
            self.expressionOfCalculations = "\(self.expressionOfCalculations)\(number)"
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

