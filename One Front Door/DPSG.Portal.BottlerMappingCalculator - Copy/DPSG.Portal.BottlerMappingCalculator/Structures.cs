using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BottlerMappingCalculator
{
    #region Structures
    public struct Segment
    {
        public SuperPoint p;
        public SuperPoint q;

        public bool contains(SuperPoint point)
        {
            if (p.ID.Equals(point.ID) || q.ID.Equals(point.ID))
                return true;
            return false;
        }
    }

    public struct PointF
    {
        public decimal X;
        public decimal Y;

        public PointF(tBottlerAccountLocation store)
        {
            X = store.Longitude.Value;
            Y = store.Latitude.Value;
        }
    }

    public struct SuperPoint
    {
        public PointF P;
        public int ID;

        public SuperPoint(PointF p, int id)
        {
            P = p;
            ID = id;
        }
    }

    #endregion

}
