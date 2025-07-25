<script lang="ts">
	import { Button } from '$lib/components/ui/button/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { PUBLIC_API } from '$env/static/public';
	import Send from '@lucide/svelte/icons/send';
	const { sessionID } = $props();
	let messages: {
		text: string;
		sources?: {
			document_location: string;
			page_content: string;
			document_url: string;
			category: string;
			title: string;
			gathered_on: string;
			modified: string;
			score: number;
		}[];
		issuer: string;
	}[] = $state([]);

	let qVal = $state('');
</script>

<h1 class="mb-9 scroll-m-20 text-center text-4xl font-extrabold tracking-tight lg:text-5xl">
	Kioskbot der Universität Bern
</h1>
<div class="flex flex-col items-center justify-center gap-4 p-4">
	{#if sessionID}
		{#if messages.length === 0}
			<p class="text-gray-500">
				Keine Nachrichten vorhanden. Bitte senden Sie eine Nachricht an den Kioskbot.
			</p>
		{:else}
			{#each messages as message}
				<div class="w-full max-w-2xl rounded-lg border border-gray-200 bg-white p-4 shadow-md">
					<p class="text-gray-700">{message.text}</p>
				</div>
			{/each}
		{/if}
		<form
			onsubmit={async (e) => {
				e.preventDefault();
				const response = await fetch(`${PUBLIC_API}/rag-agent`, {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json'
					},
					body: JSON.stringify({ text: qVal, session_id: sessionID })
				});
				const answer = await response.json();
				messages = [
					...messages,
					{
						text: answer.output,
						sources: answer.sources,
						issuer: 'bot'
					}
				];
				qVal = '';
			}}
			data-sveltekit-keepfocus
			class="flex w-md space-x-2"
		>
			<Input type="text" placeholder="Nachricht eingeben..." bind:value={qVal} />
			<Button type="submit" size="icon" class="hover:cursor-pointer"><Send /></Button>
		</form>
	{:else}
		<p>
			Der Chatbot ist momentan nur im Uni-Netz der Universität Bern erreichbar. Bitte loggen sie
			sich via VPN ins Uni-Netz ein und laden Sie die Seite erneut.
		</p>
	{/if}
</div>
