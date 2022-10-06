//
//  ViewController.swift
//  CalculatorApp
//  Description: Basic Calculator App
//  Version: v1.0.0
//  Created by Nirav Goswami on 2022-09-21.
//
//  Group #18
//  Nirav Goswami (301252385)
//  Samir Patel (301286671)
//  Esha Naik (301297804)
//

import UIKit

class ViewController: UIViewController {
    
    var resultLabelReady: Bool = true
    var result: Float = 0.0
    var operators = ["/", "x", "+", "-"] // DMAS
    //Result Label
    @IBOutlet weak var PrimaryResultLabel: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    /// Clear result label
    func clearAll(){
        PrimaryResultLabel.text = "0"
    }
    
    /// Alert handler
    func alertErrorHandler(alert: UIAlertAction!) {
        clearAll()
    }
    
    ///  Apply math operator on given left right operands
    /// - Parameters:
    ///   - op: operator + - x /
    ///   - left: left operand
    ///   - right: right operand
    /// - Returns: result
    func applyOp(op: String, left: Float, right: Float) -> Float {
        print("Operation:------",left, op, right)
        if(op != nil || left != nil || right != nil){
            switch op {
            case "+":
                return left + right
            case "-":
                return left - right
            case "x":
                return left * right
            case "/":
                if(right.isZero){
                    let alert = UIAlertController(title: "Error",
                                                  message: "Cannot divide by zero",
                                                  preferredStyle: .alert)
                    let action = UIAlertAction(title: "Clear", style: .default,
                                               handler: alertErrorHandler)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                    return 0
                }
                return left / right
            default:
                return 0
            }
        }else{
            return 0
        }
    }
    
    /// Expression Evalutor
    func Evalute() {
        // Evaluted expresion as per DMAS. Please see Example below for calculation logic
        // expression statement:>>>> 14 + 36 - 5 x 9 + 35 / 8 + 21
        // Current Array--- ["14", "+", "36", "-", "5", "x", "9", "+", "35", "/", "8", "+", "21"]
        // Operation:------ 35.0 / 8.0
        // Current Array--- ["14", "+", "36", "-", "5", "x", "9", "+", "4.375", "+", "21"]
        // Operation:------ 5.0 x 9.0
        // Current Array--- ["14", "+", "36", "-", "45.0", "+", "4.375", "+", "21"]
        // Operation:------ 14.0 + 36.0
        // Current Array--- ["50.0", "-", "45.0", "+", "4.375", "+", "21"]
        // Operation:------ 45.0 + 4.375
        // Current Array--- ["50.0", "-", "49.375", "+", "21"]
        // Operation:------ 49.375 + 21.0
        // Current Array--- ["50.0", "-", "70.375"]
        // Operation:------ 50.0 - 70.375
        // Result:--------- -20.375
        resultLabelReady = false
        var exp: String = PrimaryResultLabel.text!
        // Remove operator from expression if its in starting of expression
        if(operators.contains(String(exp.prefix(1)))){
            exp.removeFirst()
        }
        // Remove operator from expression if its in ending of expression
        if(operators.contains(String(exp.suffix(1)))){
            exp.removeLast()
        }
        exp = exp.replacingOccurrences(of: "/", with: " / ")
            .replacingOccurrences(of: "x", with: " x ")
            .replacingOccurrences(of: "+", with: " + ")
            .replacingOccurrences(of: "-", with: " - ")
            .replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression)
        
        print("expression statement:>>>>",exp)
        var token = exp.components(separatedBy: " ")
        
        while token.count > 1 {
            print("Current Array---", token)
            // Perform Operation using DMAS precedence
            var firstPreOpIdx = token.firstIndex(of: "/") ?? nil
            if(firstPreOpIdx == nil){
                firstPreOpIdx = token.firstIndex(of: "x") ?? nil
            }
            if(firstPreOpIdx == nil){
                firstPreOpIdx = token.firstIndex(of: "+") ?? nil
            }
            if(firstPreOpIdx == nil){
                firstPreOpIdx = token.firstIndex(of: "-") ?? nil
            }
            
            if(firstPreOpIdx != nil){
                let op = token[firstPreOpIdx!]
                var left = token[firstPreOpIdx!-1] != nil ? (token[firstPreOpIdx!-1]) : "0"
                var right = token[firstPreOpIdx!+1] != nil ? (token[firstPreOpIdx!+1]) : "0"
                
                left = left.replacingOccurrences(of: "−", with: "-") // replace negate sign with actual minus sign for math operation
                right = right.replacingOccurrences(of: "−", with: "-") // replace negate sign with actual minus sign for math operation
                
                if(left.components(separatedBy: ".").count > 2  || right.components(separatedBy: ".").count > 2){
                    let alert = UIAlertController(title: "Error",
                                                  message: "Invalid Decimal Number",
                                                  preferredStyle: .alert)
                    let action = UIAlertAction(title: "Clear", style: .default,
                                               handler: alertErrorHandler)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                    return
                }
                let lhs = Float(left)
                let rhs = Float(right)
                let subResult = applyOp(op: op,left: lhs!,right: rhs!)
                // Replace result in Array
                token.removeSubrange(firstPreOpIdx!-1...firstPreOpIdx!+1)
                token.insert(String(subResult), at: firstPreOpIdx!-1)
            }
        }
        
        token[0] = token[0].replacingOccurrences(of: "−", with: "") // remove negate sign
        PrimaryResultLabel.text = formatResult(result: Float(token[0]) ?? 0)
        print("PrimaryResultLabel.text", PrimaryResultLabel.text)
        resultLabelReady = true
    }
    
    /// Result Value Formatter
    /// - Parameter result: result value
    /// - Returns: formatted result value
    func formatResult(result: Float) -> String {
        if(result.truncatingRemainder(dividingBy: 1) == 0){
            return String(format: "%.0f", result)
        }else{
            var decimalPoint = 2
            // Handle dacimal point for result, max 8 decimal point
            var str = String(result).components(separatedBy: ".")
            if(str[1].count > 8){
                decimalPoint = 8
            }else{
                decimalPoint = str[1].count
            }
            return String(format: "%.*f", decimalPoint, result)
        }
    }
    
    // Event Handlers
    /// Operator Button Handler
    /// - Parameter sender: button instance
    @IBAction func OperatorButton_Pressed(_ sender: UIButton) {
        
        let button = sender as UIButton
        let currentInput = button.tag
        var exp: String = PrimaryResultLabel.text!
        if (exp.count == 19 && currentInput != 17){// Max Length for input  and  currentInput is not Equal
            return;
        }
        // Add operator in expression only if last character in expression is not operator
        if(!operators.contains(String(exp.suffix(1)))){
            switch currentInput{
            case 16: // Add
                PrimaryResultLabel.text?.append("+")
            case 15: // Subtract
                PrimaryResultLabel.text?.append("-")
            case 14: // Multiply
                PrimaryResultLabel.text?.append("x")
            case 13: // Divide
                PrimaryResultLabel.text?.append("/")
            case 17: // Equal
                Evalute()
            default:
                print("")
            }
        }else{
            if(currentInput == 17){
                Evalute()
            }
        }
    }
    
    /// Number  Button Handler
    /// - Parameter sender: button instance
    @IBAction func NumberButton_Pressed(_ sender: UIButton) {
        if (PrimaryResultLabel.text?.count == 19){ // Max Length for input
            return;
        }

        let button = sender as UIButton
        let currentInput = button.titleLabel!.text
        let resultLabelText = PrimaryResultLabel.text
        
        switch currentInput {
        case "0":
            if(resultLabelText != "0"){
                PrimaryResultLabel.text?.append("0")
            }
        case ".":
            if(resultLabelText!.last != "."){
                PrimaryResultLabel.text?.append(".")
            }
        default:
            if((resultLabelText == "0") || (!resultLabelReady)){
                PrimaryResultLabel.text = ""
                resultLabelReady = true
            }
            if(resultLabelReady){
                PrimaryResultLabel.text?.append(currentInput!)
            }
            
        }
        
    }
    /// Extra Button Handler
    /// - Parameter sender: button instance
    @IBAction func ExtraButton_Pressed(_ sender: UIButton) {
        let button = sender as UIButton
        let currentInput = button.tag
        switch currentInput {
        case 10: // Clear All
            clearAll()
        case 11: // Back
            if(PrimaryResultLabel.text!.count > 1){
                PrimaryResultLabel.text?.removeLast()
            }else{
                clearAll()
            }
        case 12: // Percent
            var currentText = PrimaryResultLabel.text
            if((currentText?.last?.isNumber) == true && currentText != "0"){
                currentText = currentText!.replacingOccurrences(of: "/", with: " / ").replacingOccurrences(of: "x", with: " x ").replacingOccurrences(of: "+", with: " + ").replacingOccurrences(of: "-", with: " - ").replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression)
                currentText?.append("%")
                var token = currentText!.components(separatedBy: " ")
                var lastNum = token[token.count - 1]
                lastNum = lastNum
                    .replacingOccurrences(of: "%", with: "")
                    .replacingOccurrences(of: "−", with: "") // remove negate sign
                
                if(lastNum.components(separatedBy: ".").count > 2){
                    let alert = UIAlertController(title: "Error",
                                                  message: "Invalid Decimal Number",
                                                  preferredStyle: .alert)
                    let action = UIAlertAction(title: "Clear", style: .default,
                                               handler: alertErrorHandler)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                    return
                }
                var percentVal = Float(lastNum)! / 100
                lastNum = lastNum.appending("%")
                var percentValStr = formatResult(result: Float(percentVal))
                PrimaryResultLabel.text = currentText?.replacingOccurrences(of: lastNum, with: percentValStr).replacingOccurrences(of: "[\\s\n]+", with: "", options: .regularExpression)
            }
            
        case 18: // Negate (plus/minus)
            var currentText = PrimaryResultLabel.text
            if((currentText?.last?.isNumber) == true && currentText != "0"){
                currentText = currentText!.replacingOccurrences(of: "/", with: " / ").replacingOccurrences(of: "x", with: " x ").replacingOccurrences(of: "+", with: " + ").replacingOccurrences(of: "-", with: " - ").replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression)
                currentText?.append("(N)") // to Identify only last number in expression e.g. 5+5+5 then only apply to last "5" and convert  5+5+-5
                var token = currentText!.components(separatedBy: " ")
                var lastNum = token[token.count - 1]
                if(lastNum.components(separatedBy: ".").count > 2){
                    let alert = UIAlertController(title: "Error",
                                                  message: "Invalid Decimal Number",
                                                  preferredStyle: .alert)
                    let action = UIAlertAction(title: "Clear", style: .default,
                                               handler: alertErrorHandler)
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                    return
                }
                // &#8722;  − , This Charecter Used to perform plus/minus functionality,
                // We have to use seperate sign to make it work with Infix Expression Evalution, We have already used regular minus sign to handle minus operator button
                
                var updatedLastNum = lastNum.prefix(1) == "−" ? lastNum.replacingOccurrences(of: "−", with: "") : "−" + lastNum // // toggle negate sign
                PrimaryResultLabel.text = currentText?.replacingOccurrences(of: lastNum, with: updatedLastNum)
                    .replacingOccurrences(of: "(N)", with: "")
                    .replacingOccurrences(of: "[\\s\n]+", with: "", options: .regularExpression)
            }
            
        default:
            print("")
        }
    }
    
    
}


