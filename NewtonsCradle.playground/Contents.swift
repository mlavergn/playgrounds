import UIKit
import PlaygroundSupport
/*:
## Newton's Cradle and UIKit Dynamics
This playground uses **UIKit Dynamics** to create a [Newton's Cradle](https://en.wikipedia.org/wiki/Newton%27s_cradle). Commonly seen on desks around the world, Newton's Cradle is a device that illustrates conservation of momentum and energy.
 
Let's create an instance of our UIKit Dynamics based Newton's Cradle. Try adding more colors to the array to increase the number of balls in the device.
*/
let newtonsCradle = NewtonsCradle(colors: [.magenta, .blue, .orange, .green])
/*:
### Size and spacing
Try changing the size and spacing of the balls and see how that changes the device. What happens if you make `ballPadding` a negative number?
*/
newtonsCradle.ballSize = CGSize(width: 60, height: 60)
newtonsCradle.ballPadding = 2.0
/*:
### Behavior
Adjust `elasticity` and `resistance` to change how the balls react to eachother.
*/
newtonsCradle.itemBehavior.elasticity = 1.0
newtonsCradle.itemBehavior.resistance = 0.2
/*:
### Shape and rotation
How does Newton's Cradle look if we use squares instead of circles and allow them to rotate?
*/
newtonsCradle.useSquaresInsteadOfBalls = false
newtonsCradle.itemBehavior.allowsRotation = false
/*:
### Gravity
Change the `angle` and/or `magnitude` of gravity to see what Newton's Device might look like in another world.
*/
newtonsCradle.gravityBehavior.angle = .pi / 2
newtonsCradle.gravityBehavior.magnitude = 1.0
/*:
### Attachment
What happens if you change `length` of the attachment behaviors to different values?
*/
for attachmentBehavior in newtonsCradle.attachmentBehaviors {
    attachmentBehavior.length = 100
}

newtonsCradle.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.liveView = newtonsCradle
PlaygroundPage.current.needsIndefiniteExecution
