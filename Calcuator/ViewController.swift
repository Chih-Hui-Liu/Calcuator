//
//  ViewController.swift
//  Calcuator
//
//  Created by Leo on 2021/1/20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var showLabel: UILabel!
    var isFinishedNumber :Bool = true //判斷是否有按+-*/c%+/-
    var displayValue:Double{
        get{
            guard let number = Double(showLabel.text!) else {//偵測非數字的值 基本上會是Error  因最後回傳需double 所以return  = 0
                return 0
            }
            return number
        }
        set{
            showLabel.text! = String(newValue)
        }
    }
    var intermediateCalcOne :(n1:Double?,calcMethod:String?)
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = UserDefaults.standard.string(forKey: "labelData")//載入上次使用的值
        showLabel.text! = context!
    }
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(showLabel.text, forKey: "labelData") //app 消失時紀錄
    }
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        isFinishedNumber = true
        change(sender: sender)
        if let calMethod = sender.currentTitle{
            if let result = calculate(symbol: calMethod,number: displayValue){
                intOrDouble(result: result)
            }
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        change(sender: sender)
        if let newValue = sender.currentTitle{
            if isFinishedNumber {
                if newValue == "."{  showLabel.text = showLabel.text! + newValue }else{ showLabel.text = newValue} //為了使按完c後原本數字是０按.要變0. 而不是.0
                
                
                isFinishedNumber = false
            }else{
                if newValue == "."{
                    let  isInt = floor(displayValue) == displayValue //floor 無條件捨去變整數 一開始按５會變５.0因跟displayValue相等5.0 = 5 因此if isInt 不會執行
                      if !isInt{
                         return
                      }
                }
                showLabel.text = showLabel.text! + newValue
            
            }
        }
        
    }
    func calculate(symbol:String,number:Double?) -> Double? {
        if let n = number {
            switch symbol {
            case "C":
                intermediateCalcOne = (n1:nil,calcMethod:nil)
                return 0
            case "+/-":
                return displayValue * -1
            case "%" :
                return displayValue * 0.01
            case "=":
                    let answer = twoNumberCalculate(n2: n)
                    intermediateCalcOne = (n1:nil,calcMethod:nil) //為了使下一個計算能用answer的值
                    return answer
              
            default:
                    if let result = twoNumberCalculate(n2:n){
                        intOrDouble(result: result)
                        intermediateCalcOne.n1 = result //與前一項做合併
                        intermediateCalcOne.calcMethod = symbol
                    }else{//第一次沒有值的時候
                        intermediateCalcOne = (n1:n,calcMethod:symbol)
                    }
            }
        }
        return nil
    }
    func change(sender:UIButton){ //點選改變背景
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            sender.backgroundColor = .gray
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
                sender.backgroundColor = .systemGreen
            }
        }
    }
    func twoNumberCalculate(n2:Double?)->Double?{
       
        if let n1 = intermediateCalcOne.n1{
            let symbol = intermediateCalcOne.calcMethod
            switch symbol {
            case "+":
                return n1 + n2!
            case "-":
                return n1 - n2!
            case "x":
                return n1 * n2!
            case "÷":
                guard n2 != 0 else {
                    showLabel.text! = "Error" //不要任意數除０
                    return nil
                }
                return n1 / n2!
            default:
                print("error")
            }
        }
        return nil
    }
    func intOrDouble(result:Double){//判斷結果整數還是double
        if (result - Double(Int(result))) == 0.0 {
            showLabel.text! = String(Int(result))
        }else{
            showLabel.text! = String(result)
        }
    }
}

