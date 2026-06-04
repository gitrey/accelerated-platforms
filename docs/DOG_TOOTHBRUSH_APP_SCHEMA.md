# CanineCare Pro: Companion App Data Schema

## Overview
This document outlines the initial data schema for the CanineCare Pro mobile application. The schema is designed to track dog profiles, brushing sessions, and hardware maintenance (brush head replacement).

## 1. User Table (Owners)
Tracks account information for the dog owners.

| Field | Type | Description |
|-------|------|-------------|
| `user_id` | UUID (PK) | Unique identifier for the user. |
| `email` | String | User's email address (unique). |
| `password_hash` | String | Hashed password for authentication. |
| `first_name` | String | User's first name. |
| `last_name` | String | User's last name. |
| `created_at` | Timestamp | Account creation date. |
| `updated_at` | Timestamp | Last account update. |

## 2. Pet Table
Stores profiles for each dog. A user can have multiple pets.

| Field | Type | Description |
|-------|------|-------------|
| `pet_id` | UUID (PK) | Unique identifier for the pet. |
| `user_id` | UUID (FK) | Reference to the owner. |
| `name` | String | Name of the dog. |
| `breed` | String | Breed of the dog. |
| `birth_date` | Date | Dog's date of birth. |
| `weight_kg` | Float | Current weight for size-based recommendations. |
| `breed_size` | Enum | [TOY, MEDIUM, LARGE] |
| `created_at` | Timestamp | Profile creation date. |

## 3. Device Table
Tracks the physical CanineCare Pro handles.

| Field | Type | Description |
|-------|------|-------------|
| `device_id` | String (PK) | Hardware serial number / MAC address. |
| `user_id` | UUID (FK) | Reference to the current owner. |
| `firmware_version` | String | Current firmware on the device. |
| `battery_level` | Integer | Percentage (0-100). |
| `last_synced_at` | Timestamp | Last Bluetooth sync time. |

## 4. BrushSession Table
Records each brushing event.

| Field | Type | Description |
|-------|------|-------------|
| `session_id` | UUID (PK) | Unique identifier for the session. |
| `pet_id` | UUID (FK) | Reference to the dog being brushed. |
| `device_id` | String (FK) | Reference to the device used. |
| `start_time` | Timestamp | Session start time. |
| `duration_seconds`| Integer | Total time ultrasonic motor was active. |
| `average_pressure`| Float | Average pressure detected by sensors. |
| `coverage_score` | Integer | Estimated cleaning coverage (0-100). |
| `treat_consumed` | Boolean | Whether the treat reservoir was used. |

## 5. ReplacementCycle Table
Tracks the usage and lifespan of interchangeable brush heads.

| Field | Type | Description |
|-------|------|-------------|
| `head_id` | UUID (PK) | Unique identifier for the specific brush head. |
| `pet_id` | UUID (FK) | Reference to the dog using this head. |
| `head_type` | Enum | [TOY, MEDIUM, LARGE] |
| `install_date` | Date | Date the head was first used. |
| `total_brushing_time`| Integer | Cumulative seconds of use for this head. |
| `status` | Enum | [ACTIVE, EXPIRED, DISCARDED] |
| `last_alert_at` | Timestamp | Last time a replacement reminder was sent. |

## 6. Relationships
- **User (1) : (N) Pet**
- **User (1) : (N) Device**
- **Pet (1) : (N) BrushSession**
- **Device (1) : (N) BrushSession**
- **Pet (1) : (N) ReplacementCycle**
