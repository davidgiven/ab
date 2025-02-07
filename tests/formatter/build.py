from build.ab import BracketedFormatter
from hamcrest import (
    assert_that,
    contains_exactly,
)


def parse(s):
    return list(BracketedFormatter().parse(s))


assert_that(parse(""), contains_exactly())
assert_that(parse("1234"), contains_exactly(("1234", None, None, None)))
assert_that(parse("1234{5678}"), contains_exactly(("1234", "5678", None, None)))
assert_that(
    parse("1234{5678}9abc"),
    contains_exactly(("1234", "5678", None, None), ("9abc", None, None, None)),
)
assert_that(parse("{5678}"), contains_exactly((None, "5678", None, None)))
assert_that(parse("{}"), contains_exactly((None, "", None, None)))
assert_that(
    parse("{1}{2}"),
    contains_exactly((None, "1", None, None), (None, "2", None, None)),
)

assert_that(parse("123}456"), contains_exactly(("123}456", None, None, None)))
assert_that(
    parse("{1}123}456"),
    contains_exactly((None, "1", None, None), ("123}456", None, None, None)),
)

assert_that(parse("{'}'}"), contains_exactly((None, "'}'", None, None)))
assert_that(parse("{'{}'}"), contains_exactly((None, "'{}'", None, None)))

assert_that(
    parse("abc{{def"),
    contains_exactly(("abc{", None, None, None), ("def", None, None, None)),
)
