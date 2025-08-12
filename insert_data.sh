#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL"TRUNCATE teams,games RESTART IDENTITY")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOAL OPPONENT_GOAL
do
if [[ $YEAR != year ]]
then
# get teams names
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
# if it empty
if [[ -z $TEAM_ID ]]
then
#insert temas
INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
then
echo "Inserted new team, $OPPONENT"
fi
fi
# get teams names
TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
# if it empty
if [[ -z $TEAM_ID ]]
then
#insert temas
INSERT_TEAMS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
if [[ $INSERT_TEAMS == "INSERT 0 1" ]]
then
echo "Inserted new team, $WINNER"
fi
fi
#get game_id
GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year='$YEAR' AND round='$ROUND' AND winner_id=( SELECT team_id FROM teams WHERE name='$WINNER') AND opponent_id=( SELECT team_id FROM teams WHERE name='$OPPONENT')")
#if it's empty
if [[ -z $GAME_ID ]]
then
#insert new one
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) VALUES('$YEAR','$ROUND','$WINNER_GOAL','$OPPONENT_GOAL',( SELECT team_id FROM teams WHERE name='$WINNER'),( SELECT team_id FROM teams WHERE name='$OPPONENT'))")
if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
then
echo "new game result was upload, $WINNER vs $OPPONENT"
fi
fi
fi
done
