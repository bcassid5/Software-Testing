var getAgeFactor = function(account){ 
    var factor;
    
    if (account.age <0 || account.age >100)
        factor= -1;
    else  if (account.age == 0 )
        factor = 1;
    else if (account.age < 2)
        factor= 5;
    else if (account.age < 5 )
        factor=10;
    else if (account.age < 10)
        factor =20;
    else if (account.age >= 10 && account.age <= 100)
        factor =50;
    return factor;
}

var getBalanceFactor=function (account){    
    var factor;

    if (account.balance < 0)
        factor = -1;
    else if (account.balance == 0)
        factor = 6;
    else if (account.balance <= 1000)
        factor = 16;
    else if (account.balance <= 50000)
        factor = 30;
    else if (account.balance <= 100000)
        factor = 70;
    else if ( account.balance <= 1000000)
        factor = 200;
    else
        factor = 500;
    return factor;
}

var AccountStatus = function (account ) {
    var factor1 = getAgeFactor(account );
    var factor2 = getBalanceFactor(account );
    var factor3 = factor1 * factor2;

    if (factor3 < 0)
        return "invalid"
    else if (factor3 <= 700)
        return "poor";
    else if (factor3 <= 3000)
        return "fair";
    else if (factor3 <= 10000)
        return "good"
    else
        return "very good";
}

var creditStatus=function (account, creditCheckMode){
    var threshold;

    if (account.credit < 0  || account.credit >800)
        return "invalid";

    if (creditCheckMode==="restricted")
        threshold = 750;
    else if (creditCheckMode==="default")
        threshold = 700;
    else  return "invalid";

    if (account.credit < threshold)
        return "bad";
    else return "good";

}

var productStatus=function (product,inventory,inventoryThreshold){ 
    var q=0;

    for (i=0;i<=inventory.length;i++){

        if (product ===inventory[i].name)
            q=inventory[i].q;
        if (q<=0)
            return "sold-out";
        else if (q <= inventoryThreshold)
            return "limited"
        else return "available"
    }
}

var orderHandling=function(account, product, inventory, inventoryThreshold, creditCheckMode){
    var aStautus=AccountStatus(account);
    var cStatus=creditStatus(account, creditCheckMode);
    var pStatus=productStatus(product, inventory, inventoryThreshold);

    if (aStautus==="invalid" || cStatus==="invalid" || pStatus==="invalid" )
        return "invalid";
    else if ((aStautus==="very good") || (aStautus==="good" && cStatus==="good") || (aStautus==="poor" && cStatus==="good" && pStatus==="available") || (aStautus==="fair" && cStatus==="good" && pStatus==="available"))
        return "accepted";
    else if ((aStautus==="good" && cStatus==="bad")||(aStautus==="fair" && cStatus==="bad" && pStatus==="available"))
        return "underReview";
    else if ((aStautus==="fair" && cStatus==="good" && pStatus==="limited") || (aStautus==="fair" && cStatus==="good" && pStatus==="sold-out") || (aStautus==="poor" && cStatus==="good" && pStatus==="limited"))
        return "pending";
    else if ((aStautus==="fair" && cStatus==="bad" && pStatus!="available") || (aStautus==="poor" && cStatus==="good" && pStatus==="sold-out") || (aStautus==="poor" && cStatus==="bad" ))
        return "rejected"
}