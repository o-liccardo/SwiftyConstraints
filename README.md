# SwiftyConstraints
Create a constraint programmatically between two UIView extending the UIView class in a Swifty way :)

## Code Example
In this case, the label that we create will be centered to the main view

let lbl = UILabel()<br>
lbl.setConstraint(pinTo: self.view, constraintType: .fixedSizeConstrainToCenter)
