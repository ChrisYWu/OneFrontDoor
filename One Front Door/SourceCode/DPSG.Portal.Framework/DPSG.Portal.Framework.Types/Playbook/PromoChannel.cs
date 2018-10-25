using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DPSG.Portal.Framework.Types
{
    public class PromoChannel
    {
        public int PromotionId { get; set; }
        public int? ChannelId { get; set; }
        public string ChannelName { get; set; }
        public int? SuperChannelId { get; set; }
        public string SuperChannelName { get; set; }

        private int _channelID;
        public int ChannelID
        {
            get
            {
                if (ChannelId != null && ChannelId != 0)
                {
                    _channelID = (int)ChannelId;
                }

                else if (SuperChannelId != null && SuperChannelId != 0)
                {
                    _channelID = (int)SuperChannelId;
                }

                return this._channelID;
            }
            
        }
        public string CreatedBy { get; set; }
    }
}
