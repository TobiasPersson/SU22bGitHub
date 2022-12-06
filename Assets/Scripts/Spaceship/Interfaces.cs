using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public interface IAttackable
{
    float Health
    {
        get;
        set;
    }

    void Attack(int damage);
}

public interface IInteractable
{
    void interact();
}
