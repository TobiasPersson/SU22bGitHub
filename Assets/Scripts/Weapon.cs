using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour //Basklass f�r alla vapen. H�r skriver jag det som alla vapen har gemensamt.
{
    public float damage = 10;
    public virtual void Attack() // En virtual funktion f�r att vapenet ska aktiveras.
    {
        print("pew pew");
    } //Virtual g�r s� att vi kan skriva �ver funktionen senare.

}
