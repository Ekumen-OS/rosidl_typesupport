# Copyright 2016-2020 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Get the concrete typesupport names to be used.
#
# The result can be overridden by setting either a CMake or environment
# variable named ``STATIC_${typesupport_type}`` (all uppercase).
# The variable can contain ROS IDL typesupport names separated by the platform
# specific path separator.
# Including an unavailable ROS IDL typesupport results in a fatal error message.
#
# :param var: the output variable name for the typesupport names
# :type var: list of strings
# :param typesupport_type: the type of the typesupport to look for
# :type typesupport_type: string
#
# @public
#
function(get_used_typesupports var typesupport_type)
  # all type supports available
  ament_index_get_resources(available_typesupports "${typesupport_type}")
  if(available_typesupports STREQUAL "")
    message(FATAL_ERROR "No '${typesupport_type}' found")
  endif()

  # use explicitly provided list if provided
  # option()
  string(TOUPPER "${typesupport_type}" typesupport_type_upper)
  if(NOT "$ENV{STATIC_${typesupport_type_upper}}" STREQUAL "")
    string(REPLACE ":" ";" STATIC_${typesupport_type_upper} "$ENV{STATIC_${typesupport_type_upper}}")
  endif()
  if(NOT "${STATIC_${typesupport_type_upper}}" STREQUAL "")
    # check if given ROS IDL typesupports are available
    foreach(typesupport ${STATIC_${typesupport_type_upper}})
      if(NOT "${typesupport}" IN_LIST available_typesupports)
        message(FATAL_ERROR
          "The ROS IDL typesupport '${typesupport}' specified in "
          "'STATIC_${typesupport_type_upper}' is not available ("
          "${available_typesupports})")
      endif()
    endforeach()
    set(selected_typesupports ${STATIC_${typesupport_type_upper}})
    message(STATUS "Filtered available ROS IDL typesupport implementations: ${selected_typesupports}")
    set(msg_used_typesupports "selected")
  else()
    set(selected_typesupports ${available_typesupports})
    set(msg_used_typesupports "all available")
  endif()

  # if only one type support is available / selected the caller might decide to
  # bypass the dynamic dispatch
  list(LENGTH selected_typesupports count)
  if(count EQUAL 1)
    set(msg_used_typesupports "single")
  endif()
  message(STATUS "Using ${msg_used_typesupports} ${typesupport_type}: ${selected_typesupports}")
  set(${var} "${selected_typesupports}" PARENT_SCOPE)
endfunction()

#
# Get the concrete typesupport names that support experimental messages.
#
# The result is the intersection of the selected/available typesupports
# and those registered as experimental-capable via the
# "available_experimental_typesupports" ament index resource.
#
# :param var: the output variable name for the experimental typesupport names
# :type var: list of strings
# :param typesupport_type: the type of the typesupport to look for
# :type typesupport_type: string
#
# @public
#
function(get_used_experimental_typesupports var typesupport_type)
  # Get all available/selected typesupports first
  get_used_typesupports(_all_typesupports "${typesupport_type}")

  # Query for experimental-capable typesupports registered in the ament index
  ament_index_get_resources(_experimental_available "available_experimental_typesupports")

  # If none are registered, return empty
  if(_experimental_available STREQUAL "")
    set(${var} "" PARENT_SCOPE)
    message(STATUS "No experimental-capable ${typesupport_type} found")
    return()
  endif()

  # Intersect: only include experimental-capable typesupports that are
  # actually selected/available
  set(_result "")
  foreach(_ts ${_all_typesupports})
    if(${_ts} IN_LIST _experimental_available)
      list(APPEND _result ${_ts})
    endif()
  endforeach()

  if(_result STREQUAL "")
    message(STATUS "No experimental-capable ${typesupport_type} in use")
  else()
    message(STATUS "Using experimental ${typesupport_type}: ${_result}")
  endif()

  set(${var} "${_result}" PARENT_SCOPE)
endfunction()
