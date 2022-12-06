using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spaceship : MonoBehaviour
{


    public Weapon[] weapons; //Array f�r alla olika vapen oavsett typ.
    public int current; //H�ller koll p� vilken jag anv�nder.

    // Start is called before the first frame update
    void Start()
    {
        weapons = GetComponents<Weapon>();  //H�mtar alla komponenter som �rver fr�n Weapon som �r kopplat till detta objektet.      
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space)) //Klickar vi space s� aktiveras det aktiva vapnet.
        {
            weapons[current].Attack();
        }
        if (Input.GetKeyDown(KeyCode.D)) //Klickar vi D s� kan vi byta vapen.
        {
            current++;
            if (current > weapons.Length - 1)
            {
                current = 0;
            }
        }
    }
}
