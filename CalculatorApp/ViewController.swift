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
    
    func clearAll(){
        print("----clearAll----")
        PrimaryResultLabel.text = ""
    }
    
    func alertErrorHandler(alert: UIAlertAction!) {
        clearAll()
    }
    func applyOp(op: String, left: Float, right: Float) -> Float {
        print("Perform Operation:--------",left, op, right)
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
                    print("Inside Division")
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
    
    func Evalute() {
        resultLabelReady = false
        var exp: String = PrimaryResultLabel.text!
        // Remove operator from expression if its in starting of expression
        if(operators.contains(String(exp.prefix(1)))){
            exp.removeFirst()
        }
        if(operators.contains(String(exp.suffix(1)))){
            exp.removeLast()
        }
        exp = exp.replacingOccurrences(of: "/", with: " / ")
        exp = exp.replacingOccurrences(of: "x", with: " x ")
        exp = exp.replacingOccurrences(of: "+", with: " + ")
        exp = exp.replacingOccurrences(of: "-", with: " - ")
//        exp = "5 + 2 x 3" // 11
//        exp = "5 + 6 x 3 - 12 / 2 + 15" //
        print("expression statement:>>>>",exp)
        var token = exp.components(separatedBy: " ")
        while token.count > 1 {
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
                var op = token[firstPreOpIdx!]
                var left = token[firstPreOpIdx!-1] != nil ? Float(token[firstPreOpIdx!-1]) : 0
                var right = token[firstPreOpIdx!+1] != nil ? Float(token[firstPreOpIdx!+1]) : 0
                print("Current Array----", token)
                var subResult = applyOp(op: op,left: left!,right: right!)
//                print("subResult----", subResult)
                token.removeSubrange(firstPreOpIdx!-1...firstPreOpIdx!+1)
//                print("token----", token)
                token.insert(String(subResult), at: firstPreOpIdx!-1)
//                print("token----", token)
            }
        }
        
        print("Final Array",token)
        PrimaryResultLabel.text = formatResult(result: Float(token[0])!)
        resultLabelReady = true
    }
    
    func formatResult(result: Float) -> String {
        if(result.truncatingRemainder(dividingBy: 1) == 0){
            return String(format: "%.0f", result)
        }else{
            return String(format: "%.2f", result)
        }
    }
    
    // Event Handlers
    @IBAction func OperatorButton_Pressed(_ sender: UIButton) {
        
        let button = sender as UIButton
        let currentInput = button.tag
        var exp: String = PrimaryResultLabel.text!
        if (exp.count == 17 && currentInput != 17){// Max Length for input 17 and  currentInput is not Equal
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
    
    @IBAction func NumberButton_Pressed(_ sender: UIButton) {
        if (PrimaryResultLabel.text?.count == 17){ // Max Length for input
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
    
    @IBAction func ExtraButton_Pressed(_ sender: UIButton) {
        let button = sender as UIButton
        let currentInput = button.tag
        switch currentInput {
        case 10: // Clear All
            clearAll()
        case 12: // Percent
            print("PrimaryResultLabel.text!", PrimaryResultLabel.text!)
        case 18: // Negate
            print("PrimaryResultLabel.text!", PrimaryResultLabel.text!)
            // &#8722;  −
        default: // Back
            if(PrimaryResultLabel.text!.count > 1){
                PrimaryResultLabel.text?.removeLast()
            }else{
                clearAll()
            }
        }
    }
    
    
}


