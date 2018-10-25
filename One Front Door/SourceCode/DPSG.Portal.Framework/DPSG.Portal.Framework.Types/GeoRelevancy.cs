using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace DPSG.Portal.Framework.Types
{
    [Serializable, DataContract]
    public class GeoRelevancy
    {
        private List<BusinessUnit> bu;
        private List<Region> region;
        private List<Branch> branch;
        private List<Area> area;

        private List<Systems> system;
        private List<Zone> zone;
        private List<Division> division;
        private List<BCRegion> bcRegion;


        [DataMember]
        public List<BusinessUnit> BU
        {
            get { return bu; }
            set { bu = value; }
        }
        [DataMember]
        public List<Region> Region
        {
            get { return region; }
            set { region = value; }
        }
        [DataMember]
        public List<Area> Area
        {
            get { return area; }
            set { area = value; }
        }

        [DataMember]
        public List<Branch> Branch
        {
            get { return branch; }
            set { branch = value; }
        }

        [DataMember]
        public List<Systems> System
        {
            get { return system; }
            set { system = value; }
        }

        [DataMember]
        public List<Zone> Zone
        {
            get { return zone; }
            set { zone = value; }
        }

        [DataMember]
        public List<Division> Division
        {
            get { return division; }
            set { division = value; }
        }

        [DataMember]
        public List<BCRegion> BCRegion
        {
            get { return bcRegion; }
            set { bcRegion = value; }
        }
    }
}
