using UnityEngine;


[ExecuteInEditMode]

public class VertexAnimationArea : MonoBehaviour
{
    [SerializeField] private float radius;
    [SerializeField] private Material targetMaterial;

    void Update()
    {
        Vector3 pos = transform.position;
        Vector4 sphere = new Vector4(pos.x, pos.y, pos.z, radius);
        targetMaterial.SetVector(name:"_SphereDesc", sphere);
    }

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, radius);
    }
#endif
}
