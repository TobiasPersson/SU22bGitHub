using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Spaceship : MonoBehaviour
{


    public Weapon[] weapons; //Array för alla olika vapen oavsett typ.
    public int current; //Håller koll på vilken jag använder.

    // Start is called before the first frame update
    void Start()
    {
        weapons = GetComponents<Weapon>();  //Hämtar alla komponenter som ärver från Weapon som är kopplat till detta objektet.      
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space)) //Klickar vi space så aktiveras det aktiva vapnet.
        {
            weapons[current].Attack();
        }
        if (Input.GetKeyDown(KeyCode.D)) //Klickar vi D så kan vi byta vapen.
        {
            current++;
            if (current > weapons.Length - 1)
            {
                current = 0;
            }
        }
    }
}
