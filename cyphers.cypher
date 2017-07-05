//name: accountByUsername
MATCH (account:Account{username: $username}) RETURN account LIMIT 1

//name: allAccount
MATCH (account:Account) RETURN account

//name: someQuery
MATCH (account:Account) RETURN account LIMIT 1

//MATCH (a:Account) WHERE a.username =~ "Lu.*" RETURN a
