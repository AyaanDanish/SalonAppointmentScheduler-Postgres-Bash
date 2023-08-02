#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~ OK HAIR ART SALON ~~~~\n"
echo -e "Welcome to OK Hair Art Salon, how can I help you?"


MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e -n "1) Cut\n2) Color\n3) Perm\n4) Style\n0) Exit\nYour choice: "
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT $SERVICE_ID_SELECTED "Cut" ;;
    2) MAKE_APPOINTMENT $SERVICE_ID_SELECTED "Color" ;;
    3) MAKE_APPOINTMENT $SERVICE_ID_SELECTED "Perm" ;;
    4) MAKE_APPOINTMENT $SERVICE_ID_SELECTED "Style" ;;
    5) EXIT ;;
    *) MAIN_MENU "We do not offer that service. Please select another." ;;
esac
}

MAKE_APPOINTMENT() {
  #enter phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have you in our records, may I get your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    echo "Welcome $CUSTOMER_NAME, you've been added to our records!"
  fi

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like to schedule your $2, $CUSTOMER_NAME?"
  read SERVICE_TIME

  INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $1, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $2 at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT() {
  echo -e "\nThank you for stopping by!\n"
}

MAIN_MENU 