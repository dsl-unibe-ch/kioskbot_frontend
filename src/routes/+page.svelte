<script lang="ts">
	import { Button } from '$lib/components/ui/button/index.js';
	import { Textarea } from '$lib/components/ui/textarea/index.js';
	import { TextareaAutosize } from 'runed';
	import { PUBLIC_API } from '$env/static/public';
	import Send from '@lucide/svelte/icons/send';
	import { onMount } from 'svelte';
	let { data } = $props();
	let { sessionID } = data;
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

	let locked = $state(false);

	onMount(async () => {
		const qEl = document.querySelector('textarea');
		if (!qEl) return;
		new TextareaAutosize({
			element: () => qEl,
			input: () => qVal
		});
	});
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
				locked = true;
				messages = [
					...messages,
					{
						text: qVal,
						issuer: 'user'
					}
				];
				// Call the RAG agent API
				if (!qVal.trim()) return; // Prevent empty messages
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
				locked = false;
			}}
			class="flex w-2xl space-x-2"
		>
			<Textarea
				placeholder="Nachricht eingeben..."
				bind:value={qVal}
				onkeydown={(e) => {
					if (e.key === 'Enter' && !e.shiftKey) {
						e.preventDefault();
						e.target.form?.requestSubmit();
					}
				}}
				data-sveltekit-keepfocus
			/>
			<Button type="submit" size="icon" class="hover:cursor-pointer" disabled={locked}
				><Send /></Button
			>
		</form>
	{:else}
		<p>
			Der Chatbot ist momentan nur im Uni-Netz der Universität Bern erreichbar. Bitte loggen sie
			sich via VPN ins Uni-Netz ein und laden Sie die Seite erneut.
		</p>
	{/if}
</div>
