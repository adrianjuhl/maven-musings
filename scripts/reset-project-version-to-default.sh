#! /bin/sh

# Reset the project.version element value to MAJOR.MINOR.${revision}

# Check that the groupId argument is present.
if [ -z "$1" ]; then
  echo "Usage: ${0##*/} <groupId> <artifactId>"
  exit
fi

# Check that the artifactId argument is present.
if [ -z "$2" ]; then
  echo "Usage: ${0##*/} <groupId> <artifactId>"
  exit
fi

# Get the group_id and artifact_id values.
group_id="$1"
artifact_id="$2"

# Find the 3 consecutive matching lines (groupId element, artifactId element, version element,
# where the groupId and artifactId values match the given parameters), extract the major and minor
# version values from the version element, and then replace the version value with:
# MAJOR.MINOR.${revision}
# Note: The $ of ${revision} needs to be double-escaped (firstly for sh, secondly for perl):
#   $ -> \$ -> \\\$
#   The second escaping must escape each of the two chars (backslash and dollar) from the result of
#   the first escaping.
perl -0777 -pi -e "s/^\n.*<groupId>${group_id}<\/groupId>.*\n.*<artifactId>${artifact_id}<\/artifactId>.*\n.*<version>([^\.]*)\.([^\.]*)\..*<\/version>.*/\n  <groupId>${group_id}<\/groupId>\n  <artifactId>${artifact_id}<\/artifactId>\n  <version>\1.\2.\\\${revision}<\/version>/gm" pom.xml

