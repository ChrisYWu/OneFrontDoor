/// <summary>
/*  Module Name         : One Portal CAML Helper
 *  Purpose             : Provide the Helper Methods to Create CAML Queries 
 *  Created Date        : 04-Feb-2013
 *  Created By          : Himanshu Panwar
 *  Last Modified Date  : 04-Feb-2013
 *  Last Modified By    : 04-Feb-2013
 *  Where to use        : In One Portal 
 *  Dependency          : 
*/
/// </summary>

#region using

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

#endregion

namespace DPSG.Portal.Framework.CommonUtils
{
    public class CamlExpression
    {
        public virtual void Render(XmlTextWriter writer)
        {
        }

        public string Where()
        {
            StringBuilder sb = new StringBuilder();
            using (XmlTextWriter writer = new XmlTextWriter(new System.IO.StringWriter(sb, System.Globalization.CultureInfo.CurrentCulture)))
            {
                writer.WriteStartElement("Where");
                this.Render(writer);
                writer.WriteEndElement();

                return sb.ToString();
            }
        }

        public CamlExpression Add(string op, CamlExpression extra)
        {
            return new CamlCompoundExpression(op, this, extra);
        }

        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();
            using (XmlTextWriter writer = new XmlTextWriter(new System.IO.StringWriter(sb, System.Globalization.CultureInfo.CurrentCulture)))
            {
                this.Render(writer);

                return sb.ToString();
            }
        }
    }

    public sealed class Caml
    {
        private Caml()
        {
        }

        public static CamlExpression And(CamlExpression left, CamlExpression right)
        {
            if (left == null)
            {
                return right;
            }

            return new CamlCompoundExpression("And", left, right);
        }

        public static CamlExpression Or(CamlExpression left, CamlExpression right)
        {
            if (left == null)
            {
                return right;
            }

            return new CamlCompoundExpression("Or", left, right);
        }

        public static CamlComparisonExpression LessThan(CamlField field, CamlValue value)
        {
            return new CamlComparisonExpression("Lt", field, value);
        }

        public static CamlComparisonExpression EqualTo(CamlField field, CamlValue value)
        {
            return new CamlComparisonExpression("Eq", field, value);
        }

        public static CamlComparisonExpression Contains(CamlField field, CamlValue value)
        {
            return new CamlComparisonExpression("Contains", field, value);
        }

        public static CamlComparisonExpression BeginsWith(string fieldname, string valueType, string value)
        {
            return new CamlComparisonExpression("BeginsWith", new CamlField(fieldname), new CamlValue(value, valueType));
        }

        public static CamlComparisonExpression LessThan(string fieldname, string valueType, string value)
        {
            return new CamlComparisonExpression("Lt", new CamlField(fieldname), new CamlValue(value, valueType));
        }

        public static CamlComparisonExpression LessOrEqual(string fieldname, string valueType, string value)
        {
            return new CamlComparisonExpression("Leq", new CamlField(fieldname), new CamlValue(value, valueType));
        }

        public static CamlComparisonExpression EqualTo(string fieldname, string valueType, string value)
        {
            return new CamlComparisonExpression("Eq", new CamlField(fieldname), new CamlValue(value, valueType));
        }

        public static CamlComparisonExpression NotEqualTo(string fieldname, string valueType, string value)
        {
            return new CamlComparisonExpression("Neq", new CamlField(fieldname), new CamlValue(value, valueType));
        }

        public static CamlComparisonExpression Contains(string fieldname, string valueType, string value)
        {
            return new CamlComparisonExpression("Contains", new CamlField(fieldname), new CamlValue(value, valueType));
        }

        public static CamlComparisonExpression GreaterOrEqual(string fieldname, string valueType, string value)
        {
            return new CamlComparisonExpression("Geq", new CamlField(fieldname), new CamlValue(value, valueType));
        }

        public static CamlExpression IsNull(string fieldname)
        {
            return new CamlCompoundExpression("IsNull",new CamlField(fieldname),null); 
        }

        public static CamlExpression Lookup(string fieldname, int lookupid)
        {
            return Caml.EqualTo(new CamlField(fieldname, true), new CamlValue(lookupid.ToString(System.Globalization.CultureInfo.CurrentCulture), "int"));
        }

        public static string CreateOrderBy(params CamlField[] fields)
        {
            StringBuilder sb = new StringBuilder();
            using (XmlTextWriter writer = new XmlTextWriter(new System.IO.StringWriter(sb, System.Globalization.CultureInfo.CurrentCulture)))
            {
                writer.WriteStartElement("OrderBy");
                if (fields != null)
                {
                    foreach (CamlField field in fields)
                    {
                        field.Render(writer);
                    }
                }
                writer.WriteEndElement();
            }

            return sb.ToString();
        }
    }

    public class CamlCompoundExpression : CamlExpression
    {
        private CamlExpression _left;
        private CamlExpression _right;
        private string _op;

        public CamlCompoundExpression(string op, CamlExpression left, CamlExpression right)
        {
            _left = left;
            _right = right;
            _op = op;
        }

        public override void Render(XmlTextWriter writer)
        {
            writer.WriteStartElement(_op);
            if (_left != null)
            _left.Render(writer);
            if(_right !=null)
            _right.Render(writer);
            writer.WriteEndElement();
        }
    }

    public class CamlComparisonExpression : CamlExpression
    {
        private CamlField _field;
        private CamlValue _value;
        private string _op;

        public string Operator
        {
            get { return _op; }
            set { _op = value; }
        }

        public CamlComparisonExpression(string op, CamlField field, CamlValue value)
        {
            _field = field;
            _value = value;
            _op = op;
        }

        public override void Render(XmlTextWriter writer)
        {
            writer.WriteStartElement(_op);
            _field.Render(writer);
            _value.Render(writer);
            writer.WriteEndElement();
        }
    }

    public class CamlField : CamlExpression
    {
        private string _fieldName;
        private bool _islookup = false;
        private bool _isDescending = false;

        public CamlField(string fieldname)
            : this(fieldname, false)
        {
        }

        public CamlField(string fieldname, bool islookup)
            : this(fieldname, islookup, false)
        {
        }

        public CamlField(string fieldname, bool islookup, bool isDescending)
        {
            _fieldName = fieldname;
            _islookup = islookup;
            _isDescending = isDescending;
        }

        public override void Render(XmlTextWriter writer)
        {
            writer.WriteStartElement("FieldRef");
            writer.WriteAttributeString("Name", _fieldName);
            if (_islookup)
            {
                writer.WriteAttributeString("LookupId", "TRUE");
            }
            if (_isDescending)
            {
                writer.WriteAttributeString("Ascending", "False");
            }
            writer.WriteEndElement();
        }
    }

    public class CamlValue : CamlExpression
    {
        private string _fieldValue;
        private string _fieldType;

        public CamlValue(string fieldvalue, string fieldtype)
        {
            _fieldValue = fieldvalue;
            _fieldType = fieldtype;
        }

        public override void Render(XmlTextWriter writer)
        {
            writer.WriteStartElement("Value");
            writer.WriteAttributeString("Type", _fieldType);
            writer.WriteString(_fieldValue);
            writer.WriteEndElement();
        }
    }
}
