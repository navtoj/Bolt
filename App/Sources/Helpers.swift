/// A simple print wrapper that only runs in debug builds.
@inline(__always)
func printd(
	_ items: Any...,
	separator: String = " ",
	terminator: String = "\n"
) {
	#if DEBUG
		print(items, separator: separator, terminator: terminator)
	#endif
}
