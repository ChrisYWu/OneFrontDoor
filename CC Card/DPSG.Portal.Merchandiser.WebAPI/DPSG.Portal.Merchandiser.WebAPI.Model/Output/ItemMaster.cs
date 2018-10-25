using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DPSG.Portal.Merchandiser.WebAPI.Model.Output
{
    public class ItemMasters : OutputBase
    {
        public List<ItemMaster> Items { get; set; }
    }

    public class ItemMaster
    {
        public string ITEM_NUMBER { get; set; }
        public string BEVID { get; set; }
        public string HANDHELD_DESCRIPTION { get; set; }
        public string PRINTOUT_DESCRIPTION { get; set; }
        public bool ACTIVE { get; set; }
        public string UPC_CASE_CODE { get; set; }
        public string UPC_UNIT_CODE { get; set; }
        public decimal UNIT_WEIGHT { get; set; }
        public string TRADEMARK { get; set; }
        public string BRAND { get; set; }
        public string PACKAGEID { get; set; }
        public string NATIONAL_ACCOUNT_CODE { get; set; }
        public int SELLING_UNIT_PER_CASE { get; set; }
        public int PIECES_PER_CASE { get; set; }
        public decimal VOLUME { get; set; }
        public string DEPOSIT_ITEM_NUMBER { get; set; }
        public string GTIN_CASE_CODE { get; set; }
        public string MATERIAL_TYPE { get; set; }
        public string MATERIAL_TAX_GROUP { get; set; }
        public string MATERIAL_TAX_CLASS { get; set; }
        public string PACKAGE_TYPE { get; set; }
        public string DEPOSIT_ITEM { get; set; }
        public decimal WHOLESALE_PRICE { get; set; }
        public string PROGRAM { get; set; }
        public string BASE_UOM { get; set; }

    }
}
