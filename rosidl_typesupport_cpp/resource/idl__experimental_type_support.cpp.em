@# generated from rosidl_typesupport_cpp/resource/idl__experimental_type_support.cpp.em
@# with input from @(package_name):@(interface_path)
@# generated code does not contain a copyright notice
@{
from rosidl_parser.definition import Message, Service
include_directives = set()
}@
@#######################################################################
@# Handle messages
@#######################################################################
@{
for message in content.get_elements_of_type(Message):
    TEMPLATE(
        'msg__type_support.cpp.em',
        package_name=package_name, interface_path=interface_path,
        message=message, include_directives=include_directives,
        type_supports=type_supports,
        force_experimental=True,
        experimental_type_supports=experimental_type_supports)
}@

@# Handle actions: intentionally omitted. Action type support handles
@# aggregate constituent message/service handles, which are already
@# generated above. No experimental action variant is needed.
@#######################################################################
@# Handle services
@#######################################################################
@{
for service in content.get_elements_of_type(Service):
    TEMPLATE(
        'srv__type_support.cpp.em',
        package_name=package_name, interface_path=interface_path,
        service=service, include_directives=include_directives,
        type_supports=type_supports,
        force_experimental=True,
        experimental_type_supports=experimental_type_supports)
}@
