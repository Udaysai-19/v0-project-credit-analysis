-- Profiles table (extends auth.users)
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT,
  age INTEGER,
  gender TEXT,
  height_cm NUMERIC,
  weight_kg NUMERIC,
  fitness_goal TEXT,
  activity_level TEXT,
  dietary_preference TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles_select_own" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "profiles_delete_own" ON public.profiles FOR DELETE USING (auth.uid() = id);

-- Health assessments
CREATE TABLE IF NOT EXISTS public.health_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  bmi NUMERIC,
  bmi_category TEXT,
  health_conditions TEXT[],
  injuries TEXT[],
  sleep_hours NUMERIC,
  stress_level TEXT,
  water_intake_liters NUMERIC,
  assessment_date TIMESTAMPTZ DEFAULT NOW(),
  ai_recommendations JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.health_assessments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "assessments_select_own" ON public.health_assessments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "assessments_insert_own" ON public.health_assessments FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "assessments_update_own" ON public.health_assessments FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "assessments_delete_own" ON public.health_assessments FOR DELETE USING (auth.uid() = user_id);

-- Workout plans
CREATE TABLE IF NOT EXISTS public.workout_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  difficulty TEXT,
  duration_weeks INTEGER,
  goal TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  ai_generated BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.workout_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "workout_plans_select_own" ON public.workout_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "workout_plans_insert_own" ON public.workout_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "workout_plans_update_own" ON public.workout_plans FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "workout_plans_delete_own" ON public.workout_plans FOR DELETE USING (auth.uid() = user_id);

-- Exercises within workout plans
CREATE TABLE IF NOT EXISTS public.exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workout_plan_id UUID NOT NULL REFERENCES public.workout_plans(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  muscle_group TEXT,
  sets INTEGER,
  reps INTEGER,
  duration_minutes INTEGER,
  rest_seconds INTEGER,
  youtube_video_id TEXT,
  day_of_week TEXT,
  order_index INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
CREATE POLICY "exercises_select_own" ON public.exercises FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "exercises_insert_own" ON public.exercises FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "exercises_update_own" ON public.exercises FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "exercises_delete_own" ON public.exercises FOR DELETE USING (auth.uid() = user_id);

-- Nutrition plans
CREATE TABLE IF NOT EXISTS public.nutrition_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  daily_calories INTEGER,
  protein_grams INTEGER,
  carbs_grams INTEGER,
  fat_grams INTEGER,
  dietary_type TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  ai_generated BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.nutrition_plans ENABLE ROW LEVEL SECURITY;
CREATE POLICY "nutrition_plans_select_own" ON public.nutrition_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "nutrition_plans_insert_own" ON public.nutrition_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "nutrition_plans_update_own" ON public.nutrition_plans FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "nutrition_plans_delete_own" ON public.nutrition_plans FOR DELETE USING (auth.uid() = user_id);

-- Meals within nutrition plans
CREATE TABLE IF NOT EXISTS public.meals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nutrition_plan_id UUID NOT NULL REFERENCES public.nutrition_plans(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  meal_type TEXT NOT NULL,
  calories INTEGER,
  protein_grams INTEGER,
  carbs_grams INTEGER,
  fat_grams INTEGER,
  ingredients JSONB,
  recipe_url TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "meals_select_own" ON public.meals FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "meals_insert_own" ON public.meals FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "meals_update_own" ON public.meals FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "meals_delete_own" ON public.meals FOR DELETE USING (auth.uid() = user_id);

-- Progress records
CREATE TABLE IF NOT EXISTS public.progress_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  weight_kg NUMERIC,
  body_fat_pct NUMERIC,
  muscle_mass_kg NUMERIC,
  waist_cm NUMERIC,
  chest_cm NUMERIC,
  arm_cm NUMERIC,
  workouts_completed INTEGER DEFAULT 0,
  calories_burned INTEGER DEFAULT 0,
  steps INTEGER DEFAULT 0,
  notes TEXT,
  recorded_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.progress_records ENABLE ROW LEVEL SECURITY;
CREATE POLICY "progress_select_own" ON public.progress_records FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "progress_insert_own" ON public.progress_records FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "progress_update_own" ON public.progress_records FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "progress_delete_own" ON public.progress_records FOR DELETE USING (auth.uid() = user_id);

-- Achievements
CREATE TABLE IF NOT EXISTS public.achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  badge_type TEXT NOT NULL,
  earned_at TIMESTAMPTZ DEFAULT NOW(),
  charity_points INTEGER DEFAULT 0
);

ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "achievements_select_own" ON public.achievements FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "achievements_insert_own" ON public.achievements FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Chat sessions for AROMI AI
CREATE TABLE IF NOT EXISTS public.chat_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT DEFAULT 'New Chat',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.chat_sessions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "chat_sessions_select_own" ON public.chat_sessions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "chat_sessions_insert_own" ON public.chat_sessions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "chat_sessions_update_own" ON public.chat_sessions FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "chat_sessions_delete_own" ON public.chat_sessions FOR DELETE USING (auth.uid() = user_id);

-- Chat messages
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.chat_sessions(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "chat_messages_select_own" ON public.chat_messages FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "chat_messages_insert_own" ON public.chat_messages FOR INSERT WITH CHECK (auth.uid() = user_id);
