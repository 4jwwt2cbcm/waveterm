// Copyright 2024, Command Line Inc.
// SPDX-License-Identifier: Apache-2.0

// Package waveobj defines the core object model for WaveTerm.
// All persistent objects in the system implement the WaveObj interface.
package waveobj

import (
	"fmt"
	"reflect"
	"strings"
)

const (
	// MetaKey is the field name used for object metadata in JSON serialization
	MetaKey = "meta"
	// OTypeKey is the field name for object type
	OTypeKey = "otype"
	// OIDKey is the field name for object ID
	OIDKey = "oid"
	// VersionKey is the field name for object version
	VersionKey = "version"
)

// ORef is a reference to a WaveObj, consisting of its type and ID.
type ORef struct {
	OType string `json:"otype"`
	OID   string `json:"oid"`
}

// String returns a human-readable representation of the ORef.
func (oref ORef) String() string {
	return fmt.Sprintf("%s:%s", oref.OType, oref.OID)
}

// IsEmpty returns true if the ORef has no type or ID.
func (oref ORef) IsEmpty() bool {
	return oref.OType == "" && oref.OID == ""
}

// ParseORef parses a string of the form "otype:oid" into an ORef.
func ParseORef(s string) (ORef, error) {
	parts := strings.SplitN(s, ":", 2)
	if len(parts) != 2 {
		return ORef{}, fmt.Errorf("invalid oref %q: expected 'otype:oid'", s)
	}
	return ORef{OType: parts[0], OID: parts[1]}, nil
}

// WaveObj is the interface that all persistent WaveTerm objects must implement.
type WaveObj interface {
	// GetOType returns the object type string (e.g. "tab", "window", "block").
	GetOType() string
}

// MetaMapType is a generic map for object metadata.
type MetaMapType map[string]any

// GetMeta retrieves a metadata value by key, returning nil if not present.
func (m MetaMapType) GetMeta(key string) any {
	if m == nil {
		return nil
	}
	return m[key]
}

// SetMeta sets a metadata value by key.
func (m MetaMapType) SetMeta(key string, val any) {
	if m == nil {
		return
	}
	m[key] = val
}

// GetOType uses reflection to retrieve the OType field from a WaveObj struct.
// Returns an empty string if the field is not found.
func GetOType(obj WaveObj) string {
	if obj == nil {
		return ""
	}
	return obj.GetOType()
}

// GetOID uses reflection to retrieve the OID field value from a WaveObj.
// The struct must have a field tagged with json:"oid".
func GetOID(obj WaveObj) string {
	if obj == nil {
		return ""
	}
	v := reflect.ValueOf(obj)
	if v.Kind() == reflect.Ptr {
		v = v.Elem()
	}
	if v.Kind() != reflect.Struct {
		return ""
	}
	t := v.Type()
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		tag := field.Tag.Get("json")
		tagName := strings.SplitN(tag, ",", 2)[0]
		if tagName == OIDKey {
			return v.Field(i).String()
		}
	}
	return ""
}

// MakeORef constructs an ORef from a WaveObj using reflection.
func MakeORef(obj WaveObj) ORef {
	return ORef{
		OType: GetOType(obj),
		OID:   GetOID(obj),
	}
}
