import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

// MARK: - URLMacro

/// Creates a non-optional URL from a static string. The string is checked to
/// be valid during compile time.
public enum URLMacro: ExpressionMacro {
	public static func expansion(
		of node: some FreestandingMacroExpansionSyntax,
		in _: some MacroExpansionContext
	) throws -> ExprSyntax {
		guard let argument = node.arguments.first?.expression,
		      let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
		      segments.count == 1,
		      case let .stringSegment(literalSegment)? = segments.first else
		{
			throw URLMacroError.requiresStaticStringLiteral
		}
		guard URL(string: literalSegment.content.text) != nil else {
			throw URLMacroError.malformedURL(literalSegment.content.text)
		}

		return "URL(string: \(argument))!"
	}
}

// MARK: - URLMacroError

enum URLMacroError: Error, CustomStringConvertible {
	case requiresStaticStringLiteral
	case malformedURL(_ input: String)

	// MARK: Computed Properties

	var description: String {
		switch self {
			case .requiresStaticStringLiteral:
				"#URL requires a static string literal"
			case let .malformedURL(input):
				"malformed url: \(input)"
		}
	}
}
