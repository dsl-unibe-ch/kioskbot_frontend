import { PUBLIC_API } from '$env/static/public';
import type { PageLoad } from './$types';

export const load = (async ({ fetch }) => {
	let sessionID = null;
	try {
		// Attempt to fetch the API root to check if the server is reachable
		const res = await fetch(`${PUBLIC_API}/`, {
			mode: 'no-cors'
		});
		if (res.ok) {
			sessionID = (await res.json())?.session_id;
		}
	} catch (error) {
		sessionID = null;
		console.error(error);
	}
	return {
		sessionID
	};
}) satisfies PageLoad;
