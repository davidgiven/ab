from build.ab import BracketedFormatter
from hamcrest import (
    assert_that,
    contains,
)


def parse(s):
    return list(BracketedFormatter().parse(s))


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
