using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    [Serializable]
    public class ProgramSystem
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public bool Disabled { get; set; }
        public int PromotionID { get; set; }
        public int ProgramId { get; set; }
        public int SequenceID { get; set; }
        public bool IsDefault { get; set; }

        public int BCSystemID {
            get
            {
                switch (Name.ToUpper())
                {
                    case "CASO":
                        return 6;
                        break;
                    case "PASO":
                        return 5;
                        break;
                    case "ISO":
                        return 7;
                        break;
                    default:
                        return 0;
                }
            }
        }
    }
}
