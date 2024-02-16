CPATH='.:..:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

if [[ -f student-submission/ListExamples.java ]]
then
    echo "File found"
else 
    echo "File not found"
    exit 1
fi

cp TestListExamples.java grading-area
cp student-submission/ListExamples.java grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java

if [[ $? -ne 0 ]]
then
    echo "Failed to compile. See error message above."
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test-output.txt
LASTLINE=$(cat test-output.txt | tail -n 2 | head -n 1)
echo $LASTLINE > last-line.txt

OK=$(echo $LASTLINE | cut -c 1-2)

if [[ $OK == "OK" ]]
then
    echo "Your score is 100%"
else
    TESTS=$(grep -o 'Tests run: \([0-9]\+\)' last-line.txt | grep -o '[0-9]\+')
    FAILURES=$(grep -o 'Failures: \([0-9]\+\)' last-line.txt | grep -o '[0-9]\+')
    SUCCESSES=$((TESTS - FAILURES))
    echo "Your score is $SUCCESSES/$TESTS"
fi
