import { createClient } from "@/lib/supabase/server"
import { ProfileView } from "@/components/dashboard/profile-view"

export default async function ProfilePage() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return null

  const [{ data: profile }, { data: assessment }] = await Promise.all([
    supabase.from("profiles").select("*").eq("id", user.id).single(),
    supabase
      .from("health_assessments")
      .select("*")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(1)
      .single(),
  ])

  return (
    <ProfileView
      user={user}
      profile={profile}
      assessment={assessment}
    />
  )
}
