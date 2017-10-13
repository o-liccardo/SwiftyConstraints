# SwiftyConstraints
SwiftyConstraints is and extension of the UIView class that enable every instance of the UIView's sub classes (UILabel, UIButton, etc) to set constraints programmatically between two UIView(or sub classes) in a Swifty way :)

## Code Example
In this case, the label that we create will be centered to the main view

let lbl = UILabel()<br>
lbl.setConstraint(pinTo: self.view, constraintType: .fixedSizeConstrainToCenter)
