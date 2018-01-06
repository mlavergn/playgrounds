import Foundation

var pattern = "[1-2]+"
var string = "The quick brown 1212 dog jumped over the lazy fox."

var regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators)
if let regex = regex {
	let matches = regex.matches(in: string, options: .withoutAnchoringBounds, range: NSMakeRange(0, string.count))

	for match in matches {
		print(match.range)
	}
}
