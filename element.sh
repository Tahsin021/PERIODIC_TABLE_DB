#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1" | xargs)
    if [[ -z $NAME ]]
    then
     echo "I could not find that element in the database."
    else
      NUM=$1
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME'" | xargs)
      TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number=$NUM" | xargs)
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$NUM" | xargs)
      MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUM" | xargs)
      BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUM" | xargs)

      echo -e "\nThe element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    fi
  fi


  if [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
    if [[ -z $NAME ]]
    then
     echo "I could not find that element in the database."
    else
      SYMBOL=$1
      NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'" | xargs)
      TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number=$NUM" | xargs)
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$NUM" | xargs)
      MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUM" | xargs)
      BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUM" | xargs)

      echo -e "\nThe element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    fi
  fi

  if [[ $1 =~ ^[A-Z][a-z][a-z]+$ ]]
  then
    NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'" | xargs)

    if [[ -z $NUM ]]
    then
      echo "I could not find that element in the database."
    else
      NAME=$1
      MASS=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number='$NUM'" | xargs)
      TYPE=$($PSQL "SELECT type FROM types RIGHT JOIN properties USING(type_id) WHERE atomic_number=$NUM" | xargs)
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$NUM" | xargs)
      MP=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUM" | xargs)
      BP=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUM" | xargs)

      echo -e "\nThe element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    fi
  fi

fi