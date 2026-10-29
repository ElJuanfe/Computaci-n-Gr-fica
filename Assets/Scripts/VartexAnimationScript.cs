using UnityEngine;

[ExecuteInEditMode]

public class VartexAnimationScript : MonoBehaviour
{
    [SerializeField] private float radius;
    [SerializeField] private Material targetMaterial;

    void Update ()
    {
        
        Vector3 pos = transform.position;
        Vector4 sphere = new Vector4(pos.x, pos.y, pos.z, w:radius);
        targetMaterial?.SetVector(name:"_Sphere",sphere);


    }

    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, radius);
    }


}
