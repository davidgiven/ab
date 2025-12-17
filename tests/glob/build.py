from build.ab import getcwd
from build.utils import glob
from hamcrest import assert_that, contains_inanyorder

assert_that(
    glob(
        ["./*.py", "./*.include", "./*.q"],
        exclude=["**/*exclude*"],
        dir="tests/glob",
    ),
    contains_inanyorder("tests/glob/testfile.include", "tests/glob/build.py"),
)

assert_that(
    glob(["**/*.q"]),
    contains_inanyorder("tests/glob/subdir/testfile.q"),
)

assert_that(
    glob(["./subdir/*.q"]),
    contains_inanyorder("tests/glob/subdir/testfile.q"),
)

assert_that(
    glob(["*.q"], dir="./subdir"),
    contains_inanyorder(),
)

assert_that(
    glob(["*.q"], dir="./subdir", relative_to="./subdir"),
    contains_inanyorder("testfile.q"),
)

assert_that(
    glob(dir="./subdir", relative_to="./subdir"),
    contains_inanyorder("testfile.q"),
)
