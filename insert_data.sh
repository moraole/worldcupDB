#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR == "year" ]]
    then
    $($PSQL "DROP TABLE games,teams")
    echo "Cleared tables"
    $($PSQL "CREATE TABLE teams(team_id SERIAL PRIMARY KEY NOT NULL, name VARCHAR(30) UNIQUE NOT NULL)")
    echo "Updated teams"
    $($PSQL "CREATE TABLE games(game_id SERIAL PRIMARY KEY NOT NULL, year INT NOT NULL, round VARCHAR(30) NOT NULL, winner_id integer REFERENCES teams(team_id) NOT NULL, opponent_id integer REFERENCES teams(team_id) NOT NULL, winner_goals INT NOT NULL, opponent_goals INT NOT NULL)")
    echo "Updated games"
  else
    echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR','$ROUND',(SELECT team_id FROM teams WHERE name='$WINNER'),(SELECT team_id FROM teams WHERE name='$OPPONENT'),'$WINNER_GOALS','$OPPONENT_GOALS')")
  fi
done
  # GAMES_TABLE=$($PSQL "CREATE TABLE games(game_id SERIAL, year INT, round VARCHAR(30))")
#   if [[ -z $TEAMS_TABLE ]]
#   then
#     echo "test"
#   fi
# done
