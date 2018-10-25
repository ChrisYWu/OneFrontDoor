using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.BottlerMappingCalculator
{
    class Program
    {
        private static List<SuperPoint> pointsList = new List<SuperPoint>();
        private static List<Segment> Segments = new List<Segment>();
        private static tBottlerTerritoryMap tMapPoint = null;

        static void Main(string[] args)
        {
            using (SDMDataContext db = new SDMDataContext())
            {
                List<vBottlerTerritoryMapHeader> combo = db.vBottlerTerritoryMapHeaders.ToList();

                foreach (var v in combo)
                {
                    pointsList = db.tBottlerAccountLocations
                        .Where(c => c.BottlerID == v.BottlerID && c.TradeMarkID == v.TradeMarkID && v.TerritoryTypeID == c.TerritoryTypeID)
                        .Select(c => new SuperPoint() { ID = c.AccountID.Value, P = new PointF(c) })
                        .ToList();

                    if (pointsList.Count() < 200)
                    {
                        Segments.Clear();
                        InitOrderdPoints();
                        Compute();

                        if (Segments.Count() > 2)
                        {
                            List<tBottlerTerritoryMap> insertionList = new List<tBottlerTerritoryMap>();

                            tMapPoint = new tBottlerTerritoryMap();
                            tMapPoint.TradeMarkID = v.TradeMarkID;
                            tMapPoint.BottlerID = v.BottlerID;
                            tMapPoint.TerritoryTypeID = v.TerritoryTypeID;
                            tMapPoint.Sequence = 1;
                            tMapPoint.Latitude = Segments[0].p.P.Y;
                            tMapPoint.Longitude = Segments[0].p.P.X;
                            insertionList.Add(tMapPoint);

                            SuperPoint startPoint = Segments[0].p;

                            tMapPoint = new tBottlerTerritoryMap();
                            tMapPoint.TradeMarkID = v.TradeMarkID;
                            tMapPoint.BottlerID = v.BottlerID;
                            tMapPoint.TerritoryTypeID = v.TerritoryTypeID;
                            tMapPoint.Sequence = 2;
                            tMapPoint.Latitude = Segments[0].q.P.Y;
                            tMapPoint.Longitude = Segments[0].q.P.X;
                            insertionList.Add(tMapPoint);

                            SuperPoint runningPoint = Segments[0].q;
                            int counter = 2;

                            while (runningPoint.ID != startPoint.ID)
                            {
                                foreach (var seg in Segments)
                                {
                                    if (seg.p.ID == runningPoint.ID)
                                    {
                                        runningPoint = seg.q;
                                        counter++;
                                        tMapPoint = new tBottlerTerritoryMap();
                                        tMapPoint.TradeMarkID = v.TradeMarkID;
                                        tMapPoint.BottlerID = v.BottlerID;
                                        tMapPoint.TerritoryTypeID = v.TerritoryTypeID;
                                        tMapPoint.Sequence = counter;
                                        tMapPoint.Latitude = seg.q.P.Y;
                                        tMapPoint.Longitude = seg.q.P.X;
                                        insertionList.Add(tMapPoint);

                                        break;
                                    }
                                }
                            }

                            db.tBottlerTerritoryMaps.InsertAllOnSubmit(insertionList);
                            db.SubmitChanges();
                        }
                    }
                }
            }
        }

        private static void InitOrderdPoints()
        {
            //Initialize all possible segments from the picked points
            for (int i = 0; i < pointsList.Count; i++)
            {
                for (int j = 0; j < pointsList.Count; j++)
                {
                    if (i != j)
                    {
                        Segment op = new Segment();
                        SuperPoint p1 = pointsList[i];
                        SuperPoint p2 = pointsList[j];
                        op.p = p1;
                        op.q = p2;

                        Segments.Add(op);
                    }
                }
            }
        }

        private static void Compute()
        {
            List<SuperPoint> ProcessingPoints = new List<SuperPoint>();
            int i = 0;
            int j = 0;
            for (i = 0; i < Segments.Count; )
            {
                //ProcessingPoints will be the points that are not in the current segment
                ProcessingPoints = new List<SuperPoint>(pointsList);

                for (j = 0; j < ProcessingPoints.Count; )
                {

                    if (Segments[i].contains(ProcessingPoints[j]))
                    {
                        ProcessingPoints.Remove(ProcessingPoints[j]);
                        j = 0;
                        continue;
                    }
                    j++;

                }

                if (!isEdge(ProcessingPoints, Segments[i]))
                {
                    Segments.Remove(Segments[i]);
                    i = 0;
                    continue;
                }
                else
                { i++; }
            }
        }

        private static bool isEdge(List<SuperPoint> processingPoints, Segment edge)
        {
            for (int k = 0; k < processingPoints.Count; k++)
            {
                if (isLeft(edge, processingPoints[k].P))
                {
                    return false;
                }
            }
            return true;
        }

        private static bool isLeft(Segment segment, PointF r)
        {
            decimal D = 0;
            decimal px, py, qx, qy, rx, ry = 0;
            //The determinant
            // | 1 px py |
            // | 1 qx qy |
            // | 1 rx ry |
            //if the determinant result is positive then the point is left of the segment
            px = segment.p.P.X;
            py = segment.p.P.Y;
            qx = segment.q.P.X;
            qy = segment.q.P.Y;
            rx = r.X;
            ry = r.Y;

            D = ((qx * ry) - (qy * rx)) - (px * (ry - qy)) + (py * (rx - qx));

            if (D <= 0)
                return false;

            return true;
        }


    }
}
