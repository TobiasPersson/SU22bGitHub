using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpaceShipMovement : MonoBehaviour
{
    [SerializeField]
    float maxSpeed = 2;

    bool shouldDampen = true;
    Rigidbody rb;
    
    public LayerMask attackableLayer;
    List<IAttackable> targets = new List<IAttackable>();
    List<Crosshair> crosshairs = new List<Crosshair>();
    public Crosshair crosshairPrefab;

    // Start is called before the first frame update
    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        //Mouse over interactable targets
        RaycastHit hit;
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit))
        {
            IInteractable interactable = hit.transform.GetComponent<IInteractable>();
            if (Input.GetMouseButtonDown(0) && interactable != null)
            {
                print("interacting with " + hit.transform.name);
            }
        }

        if (rb.velocity.magnitude > 0)
        {
            //Face the mouse
            Vector3 mousePos = Input.mousePosition;
            mousePos.z = Camera.main.transform.position.y;
            Vector3 direction = transform.position - Camera.main.ScreenToWorldPoint(mousePos);
            Quaternion rotationToMouse = Quaternion.LookRotation(direction, Vector3.up);
            transform.rotation = Quaternion.RotateTowards(transform.rotation, rotationToMouse, 1 * rb.velocity.magnitude);
        }

        if (Input.GetMouseButton(0) && rb.velocity.magnitude <= maxSpeed)
        {
            rb.AddForce(-transform.forward * 10);
        } else if (shouldDampen)
        {
            rb.velocity -= (rb.velocity / 1.25f) * Time.deltaTime;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        IAttackable target = other.GetComponent<IAttackable>();
        if (target != null)
        {
            targets.Add(target);
            crosshairs.Add(Instantiate(crosshairPrefab));
            crosshairs[crosshairs.Count - 1].target = other.transform;
        }
    }

    private void OnTriggerExit(Collider other)
    {
        IAttackable target = other.GetComponent<IAttackable>();
        if (target != null)
        {
            Destroy(crosshairs[targets.IndexOf(target)].gameObject);
            crosshairs.RemoveAt(targets.IndexOf(target));
            targets.Remove(target);
        }
    }
}
