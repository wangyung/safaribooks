#!/bin/sh

OUTPUT=share
DOWNLOAD_LIST="$OUTPUT/downloads.list"

if [ ! -s $DOWNLOAD_LIST ]; then
  echo "$DOWNLOAD_LIST is empty, please add the book ids, skip this time."
  exit 1
fi

KEEP=""

for book_id in $(cat $DOWNLOAD_LIST); do

  if [ -z $book_id ]; then
    continue
  fi
  
  #Check cookies.json
  if [ -f "share/cookies.json" ]; then
    echo "Find cookies, use cookie to login "
    python3 safaribooks.py -o $OUTPUT $book_id
  else
    python3 safaribooks.py --login -o $OUTPUT $book_id
  fi 

  # Keep the book id when error occurs.
  if [ $? -ne 0 ]; then
    echo "Error occurs, keep book_id $book_id"
    if [ -z $KEEP ]; then
      KEEP="$book_id"
    else
      KEEP=$(echo -e "$KEEP\n$book_id")
    fi
  fi  
done

# cleanup the $DOWNLOAD_LIST
if [ -z $KEEP ]; then
  echo "cleanup the download list."
  rm $DOWNLOAD_LIST
  touch $DOWNLOAD_LIST
else
  echo "keep the failed book ids in the $DOWNLOAD_LIST"
  echo $KEEP > $DOWNLOAD_LIST
fi

# Change the file permission then we can modify again.
chmod 766 $DOWNLOAD_LIST
