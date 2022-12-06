using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour //Basklass för alla vapen. Här skriver jag det som alla vapen har gemensamt.
{
    public float damage = 10;
    public virtual void Attack() // En virtual funktion för att vapenet ska aktiveras.
    {
        print("pew pew");
    } //Virtual gör så att vi kan skriva över funktionen senare.

}
