using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Laser : Weapon //Laser ärver kod från Weapon. All kod finns osynligt i Laser nu.
{
    public override void Attack() //Med override så kan vi skriva över en virtual funktion om vi vill att funktionen ska göra något annat.
    {
        //base.Attack();  Denna koden gör så att vi använder Weapons version av Attack. Detta kan vara bra om vi bara vill lägga till lite på funktionen istället för att göra något helt unikt.
        print("BZZZZZZZZZZ");
    }
}
