using System;
using System.ServiceModel.Configuration;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;

namespace DPSG.Portal.BC.Services
{
    public class NullableSupportingWebHttpBehaviourExtension : BehaviorExtensionElement
    {
        public override Type BehaviorType
        {
            get
            {
                return typeof(NullableSupportingWebHttpBehaviour);
            }
        }

        protected override object CreateBehavior()
        {
            return new NullableSupportingWebHttpBehaviour();
        }

        private class NullableSupportingWebHttpBehaviour : WebHttpBehavior
        {
            protected override QueryStringConverter GetQueryStringConverter(
                OperationDescription operationDescription)
            {
                return new NullableSupportingQueryStringConverter();
            }

            private class NullableSupportingQueryStringConverter : QueryStringConverter
            {
                public override bool CanConvert(Type type)
                {
                    if (base.CanConvert(type))
                        return true;

                    Type nullableInnerType;
                    return TryToGetNullableTypeInformation(type, out nullableInnerType)
                        && base.CanConvert(nullableInnerType);
                }

                public override object ConvertStringToValue(
                    string parameter,
                    Type parameterType)
                {
                    Type nullableInnerType;
                    if (TryToGetNullableTypeInformation(parameterType, out nullableInnerType))
                    {
                        if (string.IsNullOrEmpty(parameter))
                            return null;
                        return ConvertStringToValue(parameter, nullableInnerType);
                    }

                    return base.ConvertStringToValue(parameter, parameterType);
                }

                public override string ConvertValueToString(
                    object parameter,
                    Type parameterType)
                {
                    Type nullableInnerType;
                    if (TryToGetNullableTypeInformation(parameterType, out nullableInnerType))
                    {
                        if (parameter == null)
                            return null;
                        return ConvertValueToString(parameter, nullableInnerType);
                    }

                    return base.ConvertValueToString(parameter, parameterType);
                }

                private bool TryToGetNullableTypeInformation(Type type, out Type innerType)
                {
                    if (type == null)
                        throw new ArgumentNullException("type");

                    if (!type.IsGenericType
                    || (type.GetGenericTypeDefinition() != typeof(Nullable<>)))
                    {
                        innerType = null;
                        return false;
                    }

                    innerType = type.GetGenericArguments()[0];
                    return true;
                }
            }
        }
    }
}