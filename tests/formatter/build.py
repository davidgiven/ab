from build.ab import BracketedFormatter, substituteGlobalVariables
from hamcrest import assert_that, contains, equal_to


def parse(s):
    return list(BracketedFormatter().parse(s))


def gparse(s):
    return list(GlobalFormatter().parse(s))


assert_that(parse(""), contains())
assert_that(parse("1234"), contains(("1234", None, None, None)))
assert_that(parse("1234$[5678]"), contains(("1234", "5678", None, None)))
assert_that(
    parse("1234$[5678]9abc"),
    contains(("1234", "5678", None, None), ("9abc", None, None, None)),
)
assert_that(parse("$[5678]"), contains((None, "5678", None, None)))
assert_that(parse("$[]"), contains((None, "", None, None)))
assert_that(
    parse("$[1]$[2]"),
    contains((None, "1", None, None), (None, "2", None, None)),
)

assert_that(parse("123]456"), contains(("123]456", None, None, None)))
assert_that(
    parse("$[1]123]456"),
    contains((None, "1", None, None), ("123]456", None, None, None)),
)

assert_that(parse("$[']']"), contains((None, "']'", None, None)))
assert_that(parse("$['$[]']"), contains((None, "'$[]'", None, None)))

assert_that(parse("$$[foo]"), contains(("$[foo]", None, None, None)))
assert_that(parse("zzz$$[foo]"), contains(("zzz$[foo]", None, None, None)))
assert_that(
    parse("zzz$$[foo]zzz"), contains(("zzz$[foo]zzz", None, None, None))
)
assert_that(parse("$$[foo]zzz"), contains(("$[foo]zzz", None, None, None)))

assert_that(substituteGlobalVariables("$$(foo)"), equal_to("$(foo)"))
assert_that(substituteGlobalVariables("zzz$$(foo)"), equal_to("zzz$(foo)"))
assert_that(
    substituteGlobalVariables("zzz$$(foo)zzz"), equal_to("zzz$(foo)zzz")
)
assert_that(substituteGlobalVariables("$$(foo)zzz"), equal_to("$(foo)zzz"))
