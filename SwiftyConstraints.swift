import UIKit

/**
 Constraint type to apply. All of them have "fixedSize" so it will maintain the size of the UIView.
 */
enum ConstraintType {
    case fixedSizeConstrainToCenter
    case fixedSizeConstrainToTopLeft
    case fixedSizeConstrainToTopCenter
    case fixedSizeConstrainToTopRight
    case fixedSizeConstrainToCenterLeft
    case fixedSizeConstrainToCenterRight
    case fixedSizeConstrainToBottomLeft
    case fixedSizeConstrainToBottomCenter
    case fixedSizeConstrainToBottomRight
}

/**
 Constraint mode to apply.
 
 - normal: it'll not take in consideration the UIView's(the caller) frame dimension.
 - useSelfHeight: it'll take in account the height of the UIView(the caller).
 - useSelfWidth: it'll take in account the width of the UIView(the caller).
 - useSelfDimensions: it'll take in account the height and the width of the UIView(the caller).
 
 */
enum ConstraintMode {
    case normal
    case useSelfHeight
    case useSelfWidth
    case useSelfDimensions
}

extension UIView
{
    /**
     Create a constraint between the caller and the pinTo. It'll remove all of the precedence constraints of the caller.
     
     - Parameter pinTo: UIView to which to connect with the constraint.
     - Parameter constraintType: Type of constraint.
     - Parameter horizontalConstant: Constant that will be added to the horizontal axis. Eg. if we use the constraintType .fixedSizeConstrainToTopRight, constraintMode: .normal and set the horizontalConstant to 5, then the caller will be positioned to the TopRight of the pinTo with a distance from the right of 5. [default = 0]
     - Parameter verticalConstant: Constant that will be added to the vertical axis. Eg. if we use the constraintType .fixedSizeConstrainToTopRight, constraintMode: .normal and set the verticalConstant to 5, then the caller will be positioned to the TopRight of the pinTo with a distance from the top of 5. [default = 0]
     - Parameter constraintMode: Set if we need to take in cosideration the size of the caller. [default = .normal]
     */
    /// Example. In this case, the label that we create will be centered to the main view:
    ///
    ///     let lbl = UILabel()
    ///     lbl.setConstraint(pinTo: self.view, constraintType: .fixedSizeConstrainToCenter)
    /// ---
    func setConstraint(pinTo: UIView, constraintType: ConstraintType, horizontalConstant: Int = 0, verticalConstant: Int = 0, constraintMode: ConstraintMode = .normal)
    {
        //Disable the autoresizing mask
        self.translatesAutoresizingMaskIntoConstraints = false
        
        //if there is a superview then set with to be the superview (this is needed to differentiate between the main view and the other views and apply correctly the constraint to the view).
        let with: UIView = pinTo.superview != nil ? pinTo.superview! : pinTo
        
        //selfWidth will contain the width of the caller if there is a superview i.e is not the main view, otherwise it will contain 0
        var selfWidth = pinTo.superview != nil ? -(self.frame.width + CGFloat(horizontalConstant * 2)) : 0
        
        //Check if we need to take in account the width of the caller
        selfWidth = constraintMode == .useSelfWidth || constraintMode == .useSelfDimensions ? selfWidth + self.frame.width : selfWidth
        
        //Check if we need to take in account the height of the caller
        let selfHeight = (constraintMode == .useSelfHeight || constraintMode == .useSelfDimensions) && pinTo.superview != nil ? -self.frame.height : 0
        
        //Remove pre existing constraints
        for constraint in with.constraints
        {
            if constraint.firstItem as! NSObject == self
            {
                with.removeConstraint(constraint)
            }
        }
        
        //Apply the constraints with the mode specified
        switch constraintType {
        case .fixedSizeConstrainToCenter:
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: CGFloat(horizontalConstant))
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: CGFloat(verticalConstant))
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToTopLeft:
            //Adjustments when we don't have the .normal ConstraintMode
            let horizontalAdjustedConstant = constraintMode == .useSelfWidth || constraintMode == .useSelfDimensions ? (CGFloat(horizontalConstant) + selfWidth) * -1 : (CGFloat(horizontalConstant) + selfWidth)
            let verticalAdjustedConstant = constraintMode == .useSelfHeight || constraintMode == .useSelfDimensions ? CGFloat(verticalConstant * -1) + selfHeight : CGFloat(verticalConstant) + selfHeight * -1
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.left, multiplier: 1, constant: horizontalAdjustedConstant)
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.top, multiplier: 1, constant:  verticalAdjustedConstant)
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToTopCenter:
            //Adjustments when we don't have the .normal ConstraintMode
            let verticalAdjustedConstant = constraintMode == .useSelfHeight || constraintMode == .useSelfDimensions ? CGFloat(verticalConstant * -1) + selfHeight : CGFloat(verticalConstant) + selfHeight * -1
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: CGFloat(horizontalConstant))
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.top, multiplier: 1, constant:  verticalAdjustedConstant)
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToTopRight:
            //Adjustments when we don't have the .normal ConstraintMode
            let horizontalAdjustedConstant = constraintMode == .useSelfWidth || constraintMode == .useSelfDimensions ? (CGFloat(horizontalConstant) + selfWidth) : (CGFloat(horizontalConstant) + selfWidth) * -1
            let verticalAdjustedConstant = constraintMode == .useSelfHeight || constraintMode == .useSelfDimensions ? CGFloat(verticalConstant * -1) + selfHeight : CGFloat(verticalConstant) + selfHeight * -1
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.right, multiplier: 1, constant: horizontalAdjustedConstant)
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.top, multiplier: 1, constant:  verticalAdjustedConstant)
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToCenterLeft:
            //Adjustments when we don't have the .normal ConstraintMode
            let horizontalAdjustedConstant = constraintMode == .useSelfWidth || constraintMode == .useSelfDimensions ? (CGFloat(horizontalConstant) + selfWidth) * -1 : (CGFloat(horizontalConstant) + selfWidth)
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.left, multiplier: 1, constant:  horizontalAdjustedConstant)
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: CGFloat(verticalConstant))
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToCenterRight:
            //Adjustments when we don't have the .normal ConstraintMode
            let horizontalAdjustedConstant = constraintMode == .useSelfWidth || constraintMode == .useSelfDimensions ? (CGFloat(horizontalConstant) + selfWidth) : (CGFloat(horizontalConstant) + selfWidth) * -1
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.right, multiplier: 1, constant:  horizontalAdjustedConstant)
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: CGFloat(verticalConstant))
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToBottomLeft:
            //Adjustments when we don't have the .normal ConstraintMode
            let horizontalAdjustedConstant = constraintMode == .useSelfWidth || constraintMode == .useSelfDimensions ? (CGFloat(horizontalConstant) + selfWidth) * -1 : (CGFloat(horizontalConstant) + selfWidth)
            let verticalAdjustedConstant = constraintMode == .useSelfHeight || constraintMode == .useSelfDimensions ? (CGFloat(verticalConstant * -1) + selfHeight ) * -1 : CGFloat(verticalConstant * -1 ) + selfHeight
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.left, multiplier: 1, constant: horizontalAdjustedConstant)
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: verticalAdjustedConstant)
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToBottomCenter:
            //Adjustments when we don't have the .normal ConstraintMode
            let verticalAdjustedConstant = constraintMode == .useSelfHeight || constraintMode == .useSelfDimensions ? (CGFloat(verticalConstant * -1) + selfHeight ) * -1 : CGFloat(verticalConstant * -1 ) + selfHeight
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: CGFloat(horizontalConstant))
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: verticalAdjustedConstant)
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
            
        case .fixedSizeConstrainToBottomRight:
            //Adjustments when we don't have the .normal ConstraintMode
            let horizontalAdjustedConstant = constraintMode == .useSelfWidth || constraintMode == .useSelfDimensions ? (CGFloat(horizontalConstant) + selfWidth) : (CGFloat(horizontalConstant) + selfWidth) * -1
            let verticalAdjustedConstant = constraintMode == .useSelfHeight || constraintMode == .useSelfDimensions ? (CGFloat(verticalConstant * -1) + selfHeight ) * -1 : CGFloat(verticalConstant * -1 ) + selfHeight
            
            //Calculate constraints
            let horizontalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.right, multiplier: 1, constant:  horizontalAdjustedConstant)
            let verticalConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: pinTo, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: verticalAdjustedConstant)
            let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.width)
            let heightConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.frame.height)
            
            //Apply
            with.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        }
    }
}

