using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Laser : Weapon //Laser �rver kod fr�n Weapon. All kod finns osynligt i Laser nu.
{
    public override void Attack() //Med override s� kan vi skriva �ver en virtual funktion om vi vill att funktionen ska g�ra n�got annat.
    {
        //base.Attack();  Denna koden g�r s� att vi anv�nder Weapons version av Attack. Detta kan vara bra om vi bara vill l�gga till lite p� funktionen ist�llet f�r att g�ra n�got helt unikt.
        print("BZZZZZZZZZZ");
    }
}
